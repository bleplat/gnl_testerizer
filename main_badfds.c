/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main_multi.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/16 22:11:42 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/19 18:58:43 by bleplat          ###   ########.fr       */
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
	if (*line != NULL)
		free(*line);
	*line = NULL;
}

int			main(int argc, char **argv)
{
	int		fd0 = 3;
	int		fd1 = -1;
	int		fd2 = -2;
	int		fd3 = -77;
	int		fd4 = 44;
	int		fd5 = 1000;
	int		fd6 = 2147483647;
	int		fdx;
	char	*line = NULL;
	int		result;
	int		iarg;

	(void)argc;
	(void)argv;
	advanced = 0;
	iarg = 1;
	while (iarg < argc)
	{
		if (argv[iarg][0] == '-')
			advanced = 1;
		else if (argv[iarg][0] == '#')
		{
			fdx = atoi(&argv[iarg][1]);
			result = get_next_line(fdx, &line);
			dropline(fdx, result, &line);
			result = get_next_line(fdx, &line);
			dropline(fdx, result, &line);
			return (0);
		}
		iarg++;
	}
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
	
	result = get_next_line(fd1, (void*)0);
	dropline(fd1, result, &line);
	result = get_next_line(fd2, (void*)0);
	dropline(fd2, result, &line);
	result = get_next_line(fd3, (void*)0);
	dropline(fd3, result, &line);
	result = get_next_line(fd4, (void*)0);
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
	result = get_next_line(fd6, (void*)0);
	dropline(fd6, result, &line);
}
