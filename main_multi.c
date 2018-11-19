/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main_multi.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/16 22:11:42 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/19 20:34:43 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#include "get_next_line.h"

int			advanced;

void		dropline(int fd, int result, char **line)
{
	if (result == 0)
	{
		if (advanced)
			printf("fd %d (%d) END-OF-FILE\n", fd, result);
		return ;
	}
	if (advanced)
		printf("fd %d (%d) '%s'\n", fd, result, *line);
	else
		printf("%s\n", *line);
	free(*line);
	*line = NULL;
}

int			main(int argc, char **argv)
{
	int		fd0 = open("testfiles/multi0.txt", O_RDONLY);
	int		fd1 = open("testfiles/multi1.txt", O_RDONLY);
	int		fd2 = open("testfiles/multi2.txt", O_RDONLY);
	int		fd3 = open("testfiles/multi3.txt", O_RDONLY);
	int		fd4 = open("testfiles/multi4.txt", O_RDONLY);
	int		fd5 = open("testfiles/multi5.txt", O_RDONLY);
	int		fd6 = open("testfiles/multi6.txt", O_RDONLY);
	char	*line = NULL;
	int		result;

	(void)argc;
	(void)argv;
	advanced = 0;
	if (argc != 1)
		advanced = 1;
	while ((result = get_next_line(fd0, &line)) > 0)
		dropline(fd0, result, &line);
	dropline(fd0, result, &line);

	result = get_next_line(fd6, &line);
	dropline(fd6, result, &line);
	result = get_next_line(fd6, &line);
	dropline(fd6, result, &line);

	result = get_next_line(fd1, &line);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, &line);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, &line);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, &line);
	dropline(fd4, result, &line);
	
	result = get_next_line(fd1, &line);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, &line);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, &line);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, &line);
	dropline(fd4, result, &line);

	result = get_next_line(fd1, &line);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, &line);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, &line);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, &line);
	dropline(fd4, result, &line);

	result = get_next_line(fd1, &line);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, &line);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, &line);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, &line);
	dropline(fd4, result, &line);

	result = get_next_line(fd5, &line);
	dropline(fd5,result, &line);
	result = get_next_line(fd5, &line);
	dropline(fd5, result, &line);
	result = get_next_line(fd5, &line);
	dropline(fd5, result, &line);

	result = get_next_line(fd6, &line);
	dropline(fd6, result, &line);

	result = get_next_line(fd1, &line);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, &line);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, &line);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, &line);
	dropline(fd4, result, &line);
	result = get_next_line(fd5, &line);
	dropline(fd5, result, &line);
	result = get_next_line(fd6, &line);
	dropline(fd6, result, &line);
	result = get_next_line(-77, (void*)0);
	dropline(-77, result, &line);
}
