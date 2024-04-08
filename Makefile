# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yowoo <yowoo@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/10 01:01:33 by yowoo             #+#    #+#              #
#    Updated: 2024/04/08 13:02:46 by yowoo            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = minitalk

SERVER_C = server.c

CLIENT_C = client.c

SERVER_EXE = server

CLIENT_EXE = client

CC := cc

CFLAGS := -Wall -Werror -Wextra

INCLUDE = -Iinclude
RM = rm -rf

all: ${NAME}

${NAME}: libft server client

libft:
	cd libft && make
	
server: $(SERVER_C)
	@${CC} ${CFLAGS} ${INCLUDE} $(SERVER_C) ./libft/libft.a -o $(SERVER_EXE)

client: $(CLIENT_C)
	@${CC} ${CFLAGS} ${INCLUDE} $(CLIENT_C) ./libft/libft.a -o $(CLIENT_EXE)

clean:
	@cd libft && make clean

fclean: clean
	@cd libft && rm -f libft.a
	@${RM} ${SERVER_EXE}
	@${RM} ${CLIENT_EXE}

re: fclean all

.PHONY: all libft clean fclean re
