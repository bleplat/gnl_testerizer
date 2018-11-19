# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bleplat <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/07 09:05:04 by bleplat           #+#    #+#              #
#    Updated: 2018/11/19 20:00:11 by bleplat          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Change the above path to the path of your project, without an ending '/':
TESTED_DIR = ~/tmp/guvillar


NAME = tests

INCLUDES = libft/includes
SRC_DIR = .
OBJ_DIR = .
GNL_DIR = .

CFLAGS = -Wall -Wextra
LDFLAGS = -L libft -lft

all: import $(NAME)
	@printf "\e[36mReady to run 'sh gnl_testerizer.sh'...\e[31m\n\n"

run: all
	./runtests.sh run

### Tested Project Import ###

norminette:
	@printf "\e[36mrunning norminette...\e[31m\n"
	@cd $(TESTED_DIR) && norminette *.h | sed -e "/^Norme: /d"
	@cd $(TESTED_DIR) && norminette *.c | sed -e "/^Norme: /d"

import:
	@printf "\e[35mcopying files..\n"
	@mkdir -p $(GNL_DIR)
	cp -rf $(TESTED_DIR)/libft $(GNL_DIR)/libft
	cp -rf $(TESTED_DIR)/get_next_line.h $(GNL_DIR)/get_next_line.h
	cp -rf $(TESTED_DIR)/get_next_line.c $(GNL_DIR)/get_next_line.c
	sed -E "s/^# define BUFF_SIZE .*/\/\*# define BUFF_SIZE 0\*\//g" $(GNL_DIR)/get_next_line.h > swp && mv swp $(GNL_DIR)/get_next_line.h

$(GNL_DIR)/libft.a:
	cd $(GNL_DIR)/libft && make 1> /dev/null

### Main tests ###

main.o: main.c
	gcc $(CFLAGS) -o $@ -c main.c

MAIN_TESTS = $(NAME)_tiny $(NAME)_small $(NAME)_big

$(NAME)_tiny: get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=1 -o $@ main.o $< $(LDFLAGS)

$(NAME)_small: get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=8 -o $@ main.o $< $(LDFLAGS)

$(NAME)_big: get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=256 -o $@ main.o $< $(LDFLAGS)

### Special Tests ###

SPECIAL_TESTS = $(NAME)_multifd $(NAME)_badfds $(NAME)_highfds $(NAME)_leaks

$(NAME)_multifd: main_multi.c get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=8 -o $@ $^ $(LDFLAGS)

$(NAME)_badfds: main_badfds.c get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=8 -o $@ $^ $(LDFLAGS)

$(NAME)_leaks: main_leaks.c get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=9 -o $@ $^ $(LDFLAGS)

$(NAME)_highfds: main_highfds.c get_next_line.c
	gcc $(CFLAGS) -I $(INCLUDES) -DBUFF_SIZE=11 -o $@ $^ $(LDFLAGS)

### Special Rules ###

$(NAME): $(GNL_DIR)/libft.a main.o $(MAIN_TESTS) $(SPECIAL_TESTS)

clean:
	@printf "\e[35mcleaning...\n"
	rm -rf *.o
	rm -rf libft
	rm -f get_next_line.c get_next_line.h
	rm -f tmp_*
	rm -rf tmp

fclean: clean
	rm -rf $(NAME)_*
	rm -f test_results

re: fclean all
