/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bleplat <marvin@42.fr>                     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2018/11/15 18:34:33 by bleplat           #+#    #+#             */
/*   Updated: 2018/11/18 22:07:51 by bleplat          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>

#include "get_next_line.h"

static int	ftt_itoa_strlen_needs(int n)
{
	int		len;

	if (n == -2147483648)
		return (11);
	len = 0;
	if (n < 0)
	{
		len++;
		n *= -1;
	}
	while (n > 9)
	{
		len++;
		n /= 10;
	}
	len++;
	return (len);
}

char		*ftt_itoa(int n)
{
	char		*new_str;
	int			len;
	int			i_c;

	if (n == -2147483648)
		return (strdup("-2147483648"));
	len = ftt_itoa_strlen_needs(n);
	new_str = malloc(len + 1);
	bzero(new_str, len + 1);
	if (new_str == NULL)
		return (new_str);
	if (n < 0)
	{
		new_str[0] = '-';
		n *= -1;
	}
	i_c = len - 1;
	while (n > 9)
	{
		new_str[i_c] = '0' + (n % 10);
		n /= 10;
		i_c--;
	}
	new_str[i_c] = '0' + (n % 10);
	return (new_str);
}

int			main(int argc, char **argv)
{
	int		advanced;
	int		fd;
	char	*line;
	int		forcenull;
	int		result;
	int 	iargcf;
	int		iwaste;
	int		waste_max = 0;
	char	name[16];

	iargcf = 1;
	advanced = 0;
	fd = 0;
	forcenull = 0;
	while (iargcf < argc)
	{
		if (argv[iargcf][0] == '-')
			advanced = 1;
		else if (argv[iargcf][0] == '#')
			waste_max = atoi(&argv[iargcf][1]);
		else
			fd = open(argv[argc - 1], O_RDONLY);
		iargcf++;
	}
	iwaste = 0;
	while (iwaste < waste_max)
	{
		name[0] = '\0';
		strcpy(name, "tmp/");
		name[4] = '\0';
		strcat(name, ftt_itoa(iwaste));
		//printf("opening %s; ", name);
		open(name, O_WRONLY | O_CREAT);
		iwaste++;
	}
	while ((result = get_next_line(fd, forcenull ? (void*)0 : &line)) > 0)
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
	return (0);
}
