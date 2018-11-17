# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bleplat <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/11/07 09:05:04 by bleplat           #+#    #+#              #
#    Updated: 2018/11/17 21:30:24 by bleplat          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = tests

BUFF_SIZE = 32

TESTED_DIR = ../no_try_yet
GNL_DIR = .

INCLUDES = libft/includes
SRC_DIR = .
OBJ_DIR = .

CFLAGS = -Wall -Werror -I $(GNL_DIR)
LFLAGS = -Wall -Wextra -L libft -lft

all: norminette copy $(NAME)

norminette:
	cd $(TESTED_DIR) && norminette *.h
	cd $(TESTED_DIR) && norminette *.c

copy:
	mkdir -p $(GNL_DIR)
	cp -rf $(TESTED_DIR)/* $(GNL_DIR)/
	sed -E "s/^# define BUFF_SIZE .*/\/\*# define BUFF_SIZE 0\*\//g" $(GNL_DIR)/get_next_line.h > swp && mv swp $(GNL_DIR)/get_next_line.h

main_obj:
	gcc $(CFLAGS) -o $(GNL_DIR)/main.o -c main.c

tests_multi:
	gcc -o tests_multifd main_multi.c get_next_line.c -I libft/includes -DBUFF_SIZE=8 -L libft -lft

$(NAME): tests_multi copy main_obj gnl_obj
	gcc $(LFLAGS) -o $(NAME)_tiny main.o get_next_line.c_tiny.o
	gcc $(LFLAGS) -o $(NAME)_small main.o get_next_line.c_small.o
	gcc $(LFLAGS) -o $(NAME)_big main.o get_next_line.c_big.o

gnl_obj: get_next_line.c get_next_line.h
	gcc $(CFLAGS) -DBUFF_SIZE=1 -o $<_tiny.o -I $(INCLUDES) -c $<
	gcc $(CFLAGS) -DBUFF_SIZE=8 -o $<_small.o -I $(INCLUDES) -c $<
	gcc $(CFLAGS) -DBUFF_SIZE=256 -o $<_big.o -I $(INCLUDES) -c $<

clean:
	rm -rf *.o
	rm -rf libft
	rm -f get_next_line.c get_next_line.h

fclean: clean
	rm -rf $(NAME)_*

re: fclean all
