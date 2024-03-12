# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: yowoo <yowoo@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/03/10 01:01:33 by yowoo             #+#    #+#              #
#    Updated: 2024/03/11 12:01:05 by yowoo            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = minitalk

SERVER_C = server.c
SERVER_OBJS = $(SERVER_C:.c=.o)

CLIENT_C = client.c
CLIENT_OBJS = $(CLIENT_C:.c=.o)

LIBFT_SRCS = $(wildcard  libft/*.c)

SERVER_EXE = server.o

CLIENT_EXE = client.o

CC := cc

CFLAGS := -Wall -Werror -Wextra

INCLUDE = -Iinclude
RM = rm -rf

all: ${NAME}

${NAME}: libft server client

libft:
	cd libft && make
	
server: $(SERVER_OBJS)
	@${CC} ${CFLAGS} ${INCLUDE} ${SERVER_OBJS} $(SERVER_FILE) ./libft/libft.a -o $(SERVER_EXE)

client: $(CLIENT_OBJS)
	@${CC} ${CFLAGS} ${INCLUDE} ${CLIENT_OBJS} $(CLIENT_FILE) ./libft/libft.a -o $(CLIENT_EXE)

clean:
	@cd libft && make clean

fclean: clean
	@cd libft && rm -f libft.a
	@${RM} ${SERVER_EXE}
	@${RM} ${CLIENT_EXE}

re: fclean all

.PHONY: all libft clean fclean re
