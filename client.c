/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   client.c                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: yowoo <yowoo@student.42.fr>                +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/07 11:35:33 by yowoo             #+#    #+#             */
/*   Updated: 2024/04/08 13:04:20 by yowoo            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "./include/minitalk.h"

int	send_bits(pid_t pid, int num)
{
	int	bit;

	bit = 8;
	if (num < 0)
		return (-1);
	while (bit)
	{
		if ((num & 1) == 1)
			kill(pid, SIGUSR2);
		else
			kill(pid, SIGUSR1);
		num >>= 1;
		usleep(100);
		bit--;
	}
	return (0);
}

int	main(int argc, char	**argv)
{
	size_t			i;
	unsigned char	c;
	pid_t			pid;

	if (argc != 3)
	{
		ft_putstr_fd("ERROR: the client takes two parameters: pid, string", 1);
		return (-1);
	}
	pid = ft_atoi(argv[1]);
	send_bits(pid, ft_strlen(argv[2]));
	i = 0;
	while (i < ft_strlen(argv[2]))
	{
		c = argv[2][i];
		send_bits(pid, c);
		i++;
	}
	return (0);
}
