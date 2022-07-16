# build

	$ make build

# start container

	$ make up

# turnoff containner

	# make clean


## Criando chaves

No diretório */home/ivan/developer/keys/03-users*, editamos o
arquivo *Makefile*, informando o dono da chave.

    users  = projetoX projetoY

## Usando Gitolite em num fluxo de trabalho

Listando as informações do usuário ou grupo *cansi*.
    ssh gitolite.cansi info -p

Criando repositório *projetos/cansi/bbb* do grupo *cansi*.

    git clone gitolite.cansi:projetos/cansi/bbb

Criando um arquivo README.txt e subindo o conteúdo como
descrição do projeto.

    cat README.txt |
        ssh gitolite.cansi readme projetos/cansi/bbb set

Lendo o README do projeto.

    ssh gitolite.bash readme app/bash/command/template

Verificando as opções do comando readme
    ssh gitolite.bash readme -h

Deletando o repositório *projetos/cansi/bbb*
    ssh gitolite.cansi D unlock projetos/cansi/bbb
    ssh gitolite.cansi D rm projetos/cansi/bbb

Conferindo a remoção do projeto.

    ssh gitolite.cansi info -p
