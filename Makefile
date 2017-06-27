##
## Makefile for  in /home/mathias/Bureau/projet_epitech/synthese/ADM_automakefile_2016
## 
## Made by Mathias
## Login   <mathias@epitech.net>
## 
## Started on  Tue Jun 27 09:56:01 2017 Mathias
## Last update Tue Jun 27 10:01:23 2017 Mathias
##

SRC	=	src/test.sh

NAME	=	automakefile

all: $(NAME)

$(NAME):
	cp $(SRC) $(NAME)

clean:
	rm -f $(NAME)

fclean:
	rm -f $(NAME)

re: fclean all
