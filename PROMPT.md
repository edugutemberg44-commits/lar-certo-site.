# Zênite — hero de energia solar com a casa numa ilha flutuante

Cole este prompt no Claude Code numa pasta vazia que contenha a pasta `arquivos/` deste pacote e o `CLAUDE.md` (o guia). Ele constrói o hero, testa no navegador e deixa pronto para publicar. É **só a primeira dobra** de um site (com um bloco curto de fechamento para a página ter onde rolar); as outras seções você acrescenta depois.

---

## Parte 1 — O hero

### A marca
**Zênite** é uma instaladora de energia solar residencial de Goiânia: projeto, instalação e homologação na distribuidora em 45 dias. O público é quem tem casa e paga de R$ 400 a R$ 1.000 de luz e está juntando orçamentos.

Tom: concreto, número na frente. Fala de painel, telhado, conta e dias. Nada de "sustentabilidade", "economia inteligente" ou "energia do futuro". Todo o texto em português do Brasil, exatamente como está abaixo, com os acentos.

Cores: céu de cima para o horizonte `#2b66a3`, `#3a78b4`, `#6f9ec9`, `#b7c8d6`, `#ead9c2`, névoa `#f3e3c8`; creme `#faf6ee` (nome, texto e botão do hero); creme 2 `#f1e7d6` (fechamento); tinta `#14233a`; tinta 2 `#3b4a60`.

Tipografia (as duas livres, Google Fonts, pelo npm): **Archivo** variável com o eixo de largura (`@fontsource-variable/archivo/wdth.css`), sempre com `font-variation-settings: 'wdth' 106`; **IBM Plex Mono** 400 (`@fontsource/ibm-plex-mono/400.css`) para o HUD e os rótulos.

### A ideia
Uma casa brasileira em miniatura (paredes caiadas, porta azul, telhado de barro com 10 painéis solares, caixa d'água azul numa torre, mangueira, varal colorido, moto vermelha, cachorro caramelo) em cima de um pedaço de terra vermelha do cerrado, com raízes e pedras penduradas, **solta no céu da manhã**. Nuvens passam na frente e atrás dela, tudo em camadas recortadas que se mexem em profundidades diferentes. O nome gigante fica embaixo, sentado nas nuvens.

O risco é as camadas parecerem coladas. O que costura tudo: recortes com alfa macio (já prontos em `arquivos/`: sem pedacinhos soltos e com a base de cada nuvem desfeita, nunca reta), uma névoa quente na base da ilha, nuvens repetidas sempre com outro tamanho e espelhadas, e **um grão de filme só, por cima de tudo**. Regra de ouro: **nenhuma camada ou fundo termina numa linha reta que apareça na tela**, nem no hero nem no meio da saída; toda ponta é degradê (`mask-image`) ou fica sempre fora da área visível.

### A cena, de trás para a frente
O hero é um palco de 100svh **preso** (sticky) enquanto a página rola mais 100svh (a saída, mais abaixo). Dentro dele, camadas absolutas em tela cheia:

1. **Céu**: gradiente CSS vertical com as cores do céu acima (`#2b66a3` 0%, `#3a78b4` 20%, `#6f9ec9` 42%, `#b7c8d6` 58%, `#ead9c2` 72%, `#f3e3c8` 88%), um brilho de sol radial no canto superior direito e um clarão quente largo perto do horizonte. Uma serra distante em SVG próprio, bem apagada (`#9cb0c9`, opacidade 0,42, desfoque 1,5 px), na linha de 55% da altura, com a base desfeita por máscara (`linear-gradient(#000 30%, transparent 92%)`): o polígono tem base reta e ela apareceria através da névoa na saída.
2. **Nuvens de longe**: as pequenas (`nuvem-2`, `nuvem-7`, `nuvem-4`, um pedaço do banco `nuvem-1`), no céu dos dois lados da ilha, mais frias (`saturate(.78) contrast(.86)`) e com desfoque leve.
3. **Mar de nuvens do horizonte**: o cúmulo alto (`nuvem-3`) à esquerda e dois bancos largos (`nuvem-6`, `nuvem-1` espelhada) mais à frente, com uma faixa de névoa quente por baixo (gradiente do transparente ao `#e8d6c4`) para que **nunca apareça céu azul no pé da tela**. As faixas de névoa descem muito além da tela (até 2–3 alturas abaixo), para a ponta de baixo nunca aparecer quando as camadas sobem.
4. **A ilha** (`arquivos/img/ilha.webp`, 1446×994, fundo transparente): centro em 51,5% da largura e 40,5% da altura, largura `min(62vw, 96svh)`. Filtro `saturate(.88) contrast(.96)`. Por cima, uma camada com a **própria ilha como máscara** (`mask: url(ilha.webp)`) pintada com um gradiente: azul do céu a 16% no lado esquerdo (sombra) e névoa creme a 16–36% nos 25% de baixo (perspectiva aérea). Atrás da base, uma névoa radial creme desfocada.
5. **Nuvens da frente**: bancos largos e um cúmulo passando sobre a base da ilha e atrás do nome, com outra faixa de névoa no pé.
6. **Sombra de nuvem** para a leitura, numa camada própria e **parada**, do tamanho do palco (se ela subisse com as nuvens, a borda de baixo apareceria como faixa reta): gradientes de tinta (`rgba(22,36,60,…)`) a ~40% atrás do parágrafo, ~20% atrás do nome e ~30% subindo do pé da tela. Tem que parecer sombra de nuvem, não mancha.
7. **Texto e interface** (abaixo).
8. **Grão**: um ladrilho de ruído cinza de 180 px gerado em canvas, cobrindo a página toda em `position: fixed`, `mix-blend-mode: soft-light`, opacidade 0,3, trocando de posição em saltos (`steps`) a cada ~0,1 s.

As posições exatas de cada nuvem (desktop e celular) estão no `CLAUDE.md`.

### Texto e interface
- **Nav**: barra centrada no topo (14 px da borda), cantos de 18 px, `rgba(20,35,58,.42)` com `backdrop-filter: blur(14px)`, só com links em creme, 14 px: "Como funciona", "Simulação", "Obras", "Dúvidas". Sem logo: o logo é o nome gigante. **Some ao descer e volta ao subir** (sempre visível no topo da página e ao receber foco), assim nunca passa por cima da ilha na saída. Sobre o creme do fechamento a barra vira tinta cheia.
- **HUD** em IBM Plex Mono 12,5 px, creme com sombra suave, números tabulares:
  - canto superior esquerdo, duas linhas: "10:40 · Goiânia · 16°40′S" / "Gerando agora 4,1 kW";
  - canto superior direito: "Hoje: 9,8 de 27 kWh".
- **Nome**: "Zênite" gigante, embaixo à esquerda, Archivo peso 560, tracking −0,055em, tamanho `min(17.6vw, 31svh)`, creme `#faf6ee`. Logo depois, um **asterisco-sol** em SVG próprio (8 raios arredondados), 0,29em, alto como um expoente, girando devagar (uma volta em 48 s).
- **À direita**, alinhado com a base do nome: "10 painéis pagam a conta de luz / de uma casa em Goiânia. Projeto, / instalação e homologação em 45 dias." (três linhas fixas, Archivo 460, ~20 px, entrelinha 1,24, sombra de texto em tinta) e embaixo o botão pílula creme "Simular minha conta" com um círculo tinta e uma seta (a seta gira −45° no hover).
- **No pé, ao centro**: "[ role para ver o sistema ]" em mono 11,5 px.

### Movimento
- **Nuvens derivando sem parar** para a direita, cada camada numa velocidade (longe devagar, frente mais rápido), em **loop sem emenda**: cada nuvem anima em CSS de logo antes da borda esquerda até logo depois da direita, com atraso negativo para começar no lugar certo. Nunca dá para ver a volta.
- **Ilha flutuando**: ±0,8% da altura dela em 7,5 s (ida e volta, `ease-in-out`), com ±0,3° de giro.
- **Parallax do cursor**: cada camada se desloca, no sentido contrário ao cursor, até 26 px na horizontal e 14 px na vertical vezes a sua profundidade (céu 0,05; longe 0,18; horizonte 0,34; ilha 0,58; frente 1), suavizado (~5% por quadro). Só com mouse.
- **Entrada em camadas** (GSAP), depois que a ilha, as nuvens e as fontes carregarem (no máximo 3 s de espera): a tela começa na névoa creme; o céu aparece (1,4 s); as nuvens de longe e do horizonte sobem e aparecem; **a ilha sobe 20% da altura** e cresce de 0,94 a 1 (2,8 s); as nuvens da frente sobem; **o nome entra letra a letra por máscara** (cada letra sobe de dentro da linha, 65 ms entre elas); o asterisco gira para o lugar; o parágrafo entra linha a linha por máscara; nav e botão aparecem; **o HUD conta**: relógio de 05:40 a 10:40, geração de 0 a 4,1 kW, total de 0 a 9,8 kWh, em 1,9 s. Tudo em ~4 s.
- **HUD vivo** depois da entrada: o relógio anda em tempo real a partir de 10:40, a geração oscila de leve entre 4,0 e 4,2 kW e o total do dia soma o que está sendo gerado.
- **Saída no scroll** (a câmera desce para dentro da nuvem), pelo progresso `p` de 0 a 1 nos 100svh de rolagem do palco preso, suavizado:
  - cada camada sobe `p × velocidade × altura`: céu 0,06; longe 0,16; horizonte 0,32; ilha 0,6 (e encolhe até 86%); frente 1,25 (e cresce até 138%). **A da frente sai mais rápido.**
  - a ilha some na névoa entre `p` 0,28 e 0,58 (opacidade), antes de as nuvens a cobrirem por partes: sem pedaços de raiz e pedra soltos entre as nuvens;
  - um **muro de nuvens** enormes e um pouco desfocadas (as mais perto da câmera), em três fileiras que se sobrepõem, sobe de baixo da tela desde o começo da saída e cobre tudo;
  - nome, parágrafo e botão sobem e somem até `p` = 0,3; o HUD some até 0,22;
  - um véu creme 2 aparece de `p` 0,5 a 0,9;
  - o bloco de fechamento sobe 45svh por cima do fim do hero (`margin-top: -45svh`), com um gradiente de 45svh na borda de cima (transparente → creme 2): o conteúdo sai de dentro da nuvem, sem uma tela de creme vazio antes.

### Depois do hero: bloco de fechamento
Fundo creme 2 `#f1e7d6`, texto tinta, margens laterais iguais às do hero:
- "[ o sistema dessa casa ]" em mono;
- título "A conta de luz caiu / de R$ 780 para R$ 86." (Archivo 520, tamanho `clamp(2rem, 4.4vw, 4.6rem)`, tracking −0,045em);
- **linha de dados** de borda a borda, seis colunas separadas por fios finos, rótulo em mono e valor embaixo: Painéis "10 × 550 W" · Potência "5,5 kWp" · Geração "27 kWh/dia" · No mês "810 kWh" · Conta "R$ 780 → R$ 86" · Retorno "2 anos e 9 meses";
- botão tinta "Simular minha conta" (pílula tinta, círculo creme) e ao lado "Com a sua conta de luz em mãos, a simulação leva dois minutos.";
- rodapé em mono com "Zênite✱", "Energia solar · Goiânia, GO" e "Projeto, instalação e homologação".
Os links da nav e os botões levam a este bloco.

### Celular (tão cuidado quanto o desktop)
- Ilha centralizada com 98vw de largura, centro a 32% da altura.
- Nome em 29vw, cabendo na largura com o asterisco; embaixo dele o parágrafo (mesmas três linhas, ~16 px) e o botão, empilhados à esquerda, com 22 px de margem no pé.
- Nav em largura cheia (margens de 16 px), os quatro links distribuídos; HUD em 11 px logo abaixo dela, nos dois cantos.
- Dica de rolagem escondida. Nuvens com o layout de celular do `CLAUDE.md` (maiores em relação à tela, menos peças). Mesma saída.
- Linha de dados do fechamento em 2 colunas.

### Acessibilidade e movimento reduzido
- `h1` com o nome (a versão letra a letra fica `aria-hidden`), `alt` descritivo na ilha, nuvens com `alt=""`, foco visível.
- Com `prefers-reduced-motion: reduce`: sem deriva, flutuação, parallax, giro do asterisco e saída; o hero não fica preso (a base desfaz em creme 2 até o fechamento, que volta a `margin-top: 0`); o HUD já aparece com os valores e o relógio anda.
- O parágrafo do hero precisa ficar legível sobre qualquer nuvem que passe: confira nos prints e reforce a sombra de nuvem se precisar.

---

## Parte 2 — Como construir (stack)

- **Vite sem framework**: HTML, CSS e JS puros. Dependências pelo npm com versão travada (`--save-exact`): `gsap` (só para a entrada e a contagem do HUD), `@fontsource-variable/archivo`, `@fontsource/ibm-plex-mono`, e `vite` como devDependency. Sem Lenis, sem Three. Scripts: `dev` (`vite --port 5190`), `build`, `preview`.
- Copie `arquivos/img/*` para `public/img/` e `arquivos/favicon.svg` para `public/`. Em `arquivos/camadas/` estão as mesmas camadas em PNG com alfa, em tamanho cheio, para editar (já limpas: um pedaço de alfa só por imagem e a base das nuvens desfeita).
- Organização: `src/styles/tokens.css` (todas as cores, fontes e tamanhos em variáveis CSS), `src/styles/base.css` (botão pílula, grão), `src/data/nuvens.js` (tamanho de cada nuvem e os layouts desktop/celular do guia), `src/data/sistema.js` (os números da casa), **uma seção por arquivo** em `src/sections/` (`nav`, `hero`, `fecho`, cada uma com marcação e CSS próprio) e **o motion em módulos próprios** em `src/motion/`: `nuvens.js` (monta e posiciona as nuvens), `palco.js` (cursor + saída, por quadro), `entrada.js` (GSAP), `hud.js` (contagem e relógio), `nav.js` (some ao descer, volta ao subir), `grao.js`.
- Cada camada tem duas caixas: a de fora recebe o `transform` do cursor e da saída (escrito pelo `palco.js` só quando algo muda); a de dentro recebe a entrada (GSAP). Assim as duas nunca brigam.
- Deriva e flutuação em animação CSS (roda no compositor). Pause-as com o hero fora da tela (`IntersectionObserver` + `animation-play-state`).
- Siga o `CLAUDE.md` (guia) para os números, as posições das nuvens e a checagem.
- Ao terminar: `npm run build` precisa passar sem erro e o console fica limpo. Confira com prints headless (Playwright) em 1456×840 e 390×844: o hero depois da entrada (~5 s), a saída em 15, 30, 45, 62 e 80% (desktop) e 45% (celular) e o fechamento, ampliando com `page.screenshot({ clip })`. Procure linha reta horizontal e pedacinho solto: não pode haver nenhum. Compare com a descrição acima e ajuste até bater.
