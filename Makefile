# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bleplat <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/07 09:05:04 by bleplat           #+#    #+#              #
#    Updated: 2018/11/19 13:56:18 by bleplat          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

TESTED_DIR = ../try0


NAME = tests

INCLUDES = libft/includes
SRC_DIR = .
OBJ_DIR = .
GNL_DIR = .

CFLAGS = -Wall -Wextra
LDFLAGS = -L libft -lft

all: norminette copy $(NAME)
	@printf "\e[36mLAUNCHING TESTS...\e[31m\n\n"
	@sh runtests.sh

norminette:
	@printf "\e[36mrunning norminette...\e[31m\n"
	@cd $(TESTED_DIR) && norminette *.h | sed -e "/^Norme: /d"
	@cd $(TESTED_DIR) && norminette *.c | sed -e "/^Norme: /d"

copy:
	@printf "\e[35mcopying files..\n"
	@mkdir -p $(GNL_DIR)
	@cp -rf $(TESTED_DIR)/libft $(GNL_DIR)/libft
	@cp -rf $(TESTED_DIR)/get_next_line.h $(GNL_DIR)/get_next_line.h
	@cp -rf $(TESTED_DIR)/get_next_line.c $(GNL_DIR)/get_next_line.c
	@sed -E "s/^# define BUFF_SIZE .*/\/\*# define BUFF_SIZE 0\*\//g" $(GNL_DIR)/get_next_line.h > swp && mv swp $(GNL_DIR)/get_next_line.h

libft_lib:
	cd $(GNL_DIR)/libft && make 1> /dev/null

main.o: main.c
	@gcc $(CFLAGS) -o $@ -c main.c

tests_multifd: main_multi.c
	@gcc -o $@ main_multi.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=8 $(LDFLAGS)

tests_badfds: main_badfds.c
	@gcc -o $@ main_badfds.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=8 $(LDFLAGS)

tests_leaks: main_leaks.c
	@gcc -o $@ main_leaks.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=9 $(LDFLAGS)

tests_highfds: main_highfds.c
	@gcc -o $@ main_highfds.c get_next_line.c -I $(INCLUDES) -DBUFF_SIZE=9 $(LDFLAGS)

gnl_obj: get_next_line.c get_next_line.h
	@printf "\e[35m"
	@gcc $(CFLAGS) -DBUFF_SIZE=1 -o $<_tiny.o -I $(INCLUDES) -c $<
	@gcc $(CFLAGS) -DBUFF_SIZE=8 -o $<_small.o -I $(INCLUDES) -c $<
	@gcc $(CFLAGS) -DBUFF_SIZE=256 -o $<_big.o -I $(INCLUDES) -c $<

$(NAME): copy main.o gnl_obj libft_lib tests_highfds tests_leaks tests_badfds tests_multifd
	@printf "\e[35m"
	@gcc -o $(NAME)_tiny main.o get_next_line.c_tiny.o $(LDFLAGS)
	@gcc -o $(NAME)_small main.o get_next_line.c_small.o $(LDFLAGS)
	@gcc -o $(NAME)_big main.o get_next_line.c_big.o $(LDFLAGS)

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
