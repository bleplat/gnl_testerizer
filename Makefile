# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bleplat <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/07 09:05:04 by bleplat           #+#    #+#              #
#    Updated: 2018/11/19 14:37:31 by bleplat          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Change the above path to the path of your project, without an ending '/':
TESTED_DIR = ../try0
# Then do 'make re'

NAME = tests

INCLUDES = libft/includes
SRC_DIR = .
OBJ_DIR = .
GNL_DIR = .

CFLAGS = -Wall -Wextra
LDFLAGS = -L libft -lft

all: norminette import $(NAME)
	@printf "\e[36mLAUNCHING TESTS...\e[31m\n\n"
	@sh runtests.sh

### Tested Project Import ###

norminette:
	@printf "\e[36mrunning norminette...\e[31m\n"
	@cd $(TESTED_DIR) && norminette *.h | sed -e "/^Norme: /d"
	@cd $(TESTED_DIR) && norminette *.c | sed -e "/^Norme: /d"

import:
	@printf "\e[35mcopying files..\n"
	@mkdir -p $(GNL_DIR)
	@cp -rf $(TESTED_DIR)/libft $(GNL_DIR)/libft
	@cp -rf $(TESTED_DIR)/get_next_line.h $(GNL_DIR)/get_next_line.h
	@cp -rf $(TESTED_DIR)/get_next_line.c $(GNL_DIR)/get_next_line.c
	@sed -E "s/^# define BUFF_SIZE .*/\/\*# define BUFF_SIZE 0\*\//g" $(GNL_DIR)/get_next_line.h > swp && mv swp $(GNL_DIR)/get_next_line.h

$(GNL_DIR)/libft.a:
	cd $(GNL_DIR)/libft && make 1> /dev/null

### Main tests ###

main.o: main.c
	@gcc $(CFLAGS) -o $@ -c main.c

MAIN_TESTS = $(NAME)_tiny $(NAME)_small $(NAME)_big

$(NAME)_tiny: get_next_line.c get_next_line.h
	@gcc $(CFLAGS) -DBUFF_SIZE=1 -o $@ -I $(INCLUDES) main.o $< $(LDFLAGS)

$(NAME)_small: get_next_line.c get_next_line.h
	@gcc $(CFLAGS) -DBUFF_SIZE=8 -o $@ -I $(INCLUDES) main.o $< $(LDFLAGS)

$(NAME)_big: get_next_line.c get_next_line.h
	@gcc $(CFLAGS) -DBUFF_SIZE=256 -o $@ -I $(INCLUDES) main.o $< $(LDFLAGS)

### Special Tests ###

SPECIAL_TESTS = tests_multifd tests_badfds tests_highfds tests_leaks

tests_multifd: main_multi.c
	@gcc -o $@ main_multi.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=8 $(LDFLAGS)

tests_badfds: main_badfds.c
	@gcc -o $@ main_badfds.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=8 $(LDFLAGS)

tests_leaks: main_leaks.c
	@gcc -o $@ main_leaks.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=9 $(LDFLAGS)

tests_highfds: main_highfds.c
	@gcc -o $@ main_highfds.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=9 $(LDFLAGS)

### Special Rules ###

$(NAME): $(GNL_DIR)/libft.a main.o $(MAIN_TESTS) $(SPECIAL_TESTS)

clean:
	@printf "\e[33m"
	rm -rf *.o
	rm -rf libft
	rm -f get_next_line.c get_next_line.h
	rm -f tmp_*
	rm -rf tmp

fclean: clean
	@printf "\e[33m"
	rm -rf $(NAME)_*
	rm -f test_results

re: fclean all
