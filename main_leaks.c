/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/15 18:34:33 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/18 17:28:06 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#include "get_next_line.h"

int			main(int argc, char **argv)
{
	int		advanced;
	int		fd;
	char	*line;
	int		result;
	int 	iargcf;

	iargcf = 1;
	advanced = 0;
	fd = 0;
	while (iargcf < argc)
	{
		if (argv[iargcf][0] == '-')
			advanced = 1;
		else
			fd = open(argv[argc - 1], O_RDONLY);
		iargcf++;
	}
	while ((result = get_next_line(fd, &line)) > 0)
	{
		if (advanced)
			printf("(%d) '%s'\n", result, line);
		else
			printf("%s\n", line);
		free(line);
	}
	if (advanced && result < 0)
		printf("(%d) RESULT-IS-ERROR-CODE\n", result);
	else if (advanced)
		printf("(%d) END-OF-FILE\n", result);
	while (1);
}
