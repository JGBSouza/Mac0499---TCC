- Vai copiando e colando os parágrafos/trechos num corretor ortográfico. Pro português, acho que o languagetool.org/ funciona bem, mas se conhecer outro e preferir, fique a vontade. Só cheque se o texto tá ortográficamente correto.
- Coloquei comentários (usando o comando `\todo{comentario}`) inline e nas margens tanto no fonte quanto no PDF gerado. Pra não deixar o fonte muito caótico, repare que fiz quebras no meio do parágrafo original para os comentários inline; então, quando for atacar um todo, remova o comando a quebra de linha no final.
- Parece que tem referências faltando no bibtex, como o TCC meu e do Rubens e o paper do kw do SBES.
- Tem `\todo{}`s que não exigem nenhuma ação.
- O nome "oficial" do kw é Kworkflow. Use isto ao invés de Kernel Workflow e use kw no minúsculo, não no maiúsculo.
- Vou confirmar com o Paulo onde, mas temos que citar o paper nosso do SBES do kw, quando falarmos dele. Não sei se na primeira vez que falarmos do kw (na intro) ou se no capítulo 2, mas temos que fazer esta ref.
- Questão de estilo, porém o uso de contruções usando `-` como separador (ex.: `Linux - um kernel de um SO - ...`) não é visto tão bem e pessoalmente acho que deixa mais truncado e com cara de grammarly/LLM (não estou te acusando de nada, claro). Você pode substituir por vírgulas que dá na mesma, porém é algo de estilo, então fica total ao seu critério.
- LaTeX é problemático em vários pontos. Um deles é pra colocar aspas duplas. Em LaTeX, o comum é fazer assim:
    ```latex
    ``Eu sou um trecho entre aspas duplas''
    ```
