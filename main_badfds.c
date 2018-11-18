/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main_multi.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/16 22:11:42 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/18 18:13:21 by bleplat          ###   ########.fr       */
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
	char	*line;
	int		result;

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
