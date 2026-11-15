# CLAUDE.md — Zênite

Guia do hero da Zênite (energia solar em Goiânia, casa numa ilha flutuante). Leia antes de mexer em qualquer arquivo. O prompt descreve o hero; este guia guarda as regras e os números que fazem ele parecer uma cena só, e não camadas coladas.

## O que não pode se perder
1. **Uma cena só.** Ilha e nuvens têm a mesma luz (sol da manhã pela direita). Nada de borda dura, halo branco ou sombra projetada nos recortes: use os PNG/WebP de `arquivos/` como estão (já limpos: sem ilhas de alfa soltas, base das nuvens desfeita seguindo o contorno).
2. **Nenhuma linha reta na tela, nunca.** Toda camada ou fundo que termina dentro da área visível em algum momento da saída precisa terminar em degradê (`mask-image`) ou ser maior que a tela. Já pegaram: a base reta dos bancos de nuvem, a base do polígono da serra, a ponta de baixo das faixas de névoa e a borda de baixo da sombra de nuvem quando ela subia com a camada da frente.
3. **Profundidade de verdade.** Quanto mais perto, mais rápido deriva, mais se mexe com o cursor, mais rápido sai no scroll. As de longe são menores, mais frias e um pouco desfocadas; as do muro (as mais perto) são enormes e desfocadas.
4. **Nunca céu azul no pé da tela.** As faixas de névoa embaixo dos mares de nuvens existem para isso.
5. **A mesma nuvem nunca aparece duas vezes lado a lado.** Repetir é normal (são 6 recortes), mas sempre em outra camada, outro tamanho, espelhada ou com outra opacidade.
6. **Um grão só, por cima de tudo** (inclusive do texto). Nada de grão por camada.
7. **Texto legível sempre.** O parágrafo do hero fica sobre nuvens que passam: a sombra de nuvem atrás dele e a sombra no texto não podem sair.

## Design system
- Cores, fontes e tamanhos em `src/styles/tokens.css`. Margem lateral `clamp(16px, 2.3vw, 40px)`.
- Nome: `font-size: min(17.6vw, 31svh)` (celular 29vw), peso 560, `wdth` 106, tracking −0,055em, entrelinha 1. Cada letra em `span` inline-block dentro de uma linha com `overflow: hidden` e folga de 0,06em em cima (o circunflexo). Asterisco: `width/height: .29em`, `vertical-align: .43em`.
- Texto do hero: `clamp(1rem, 1.38vw, 1.4rem)`, peso 460; sombra `0 1px 2px rgba(20,35,58,.32), 0 2px 18px rgba(20,35,58,.55)`.
- Grade do texto: uma grade de duas colunas (`1fr auto`) presa ao pé do palco com `align-items: end; align-content: end`, padding de baixo 7,4svh; no celular uma coluna, padding de baixo 22 px. Sem `align-content: end`, no celular o nome flutua no meio da tela.
- Botão: pílula de 52 px, padding `0 7px 0 26px`, círculo de 38 px.

## Nuvens — números
Arquivos `nuvem-N.webp` e tamanho natural: 1 = 1110×240 (banco largo), 2 = 350×211 (cúmulo pequeno), 3 = 705×369 (cúmulo alto), 4 = 434×255 (médio), 6 = 1208×246 (banco largo), 7 = 279×210 (fragmento).

Unidade `u`: desktop `min(L, 1.9·A) / 100`; celular (≤ 760 px) `max(L, 0.62·A) / 100` (L = largura, A = altura do palco).
Cada nuvem: `x` = borda esquerda inicial (fração de L), `cy` = centro vertical (fração de A), `w` = largura em `u`, `e` = espelhada, `a` = opacidade.

Deriva: de `início = −w − 90px` até `início + L + w + 180px`; duração = percurso / (velocidade × u); atraso negativo = fase × duração, com fase = `(x·L − início) / percurso`. Velocidades (u/s): longe 0,32, horizonte 0,55, frente 0,95, muro 0,5. Desfoque (px × u/14): longe 0,8, horizonte 0,3, muro 2,2.

**Desktop**
| camada | n · x · cy · w (extras) |
|---|---|
| longe | 2 · 0,03 · 0,36 · 11 (e, a .8) · 7 · 0,77 · 0,22 · 9 (a .75) · 4 · 0,89 · 0,40 · 12 (a .8) · 1 · 0,60 · 0,33 · 18 (a .55) · 7 · 0,16 · 0,19 · 6 (e, a .5) |
| horizonte | 3 · −0,05 · 0,53 · 33 · 6 · 0,16 · 0,67 · 74 · 1 · 0,60 · 0,61 · 52 (e) · 4 · 0,86 · 0,53 · 19 (e) |
| frente | 6 · 0,30 · 0,83 · 72 (e) · 1 · −0,20 · 0,88 · 80 · 3 · 0,72 · 0,79 · 36 (e) · 7 · 0,06 · 0,74 · 13 · 2 · 0,50 · 0,97 · 30 |
| muro | 3 · −0,05 · 0,17 · 70 · 4 · 0,60 · 0,15 · 52 (e) · 6 · −0,30 · 0,42 · 160 (e) · 1 · 0,36 · 0,47 · 140 · 3 · 0,42 · 0,66 · 80 (e) · 6 · −0,20 · 0,78 · 170 |

**Celular**
| camada | n · x · cy · w (extras) |
|---|---|
| longe | 2 · −0,12 · 0,22 · 34 (e, a .85) · 7 · 0,66 · 0,17 · 22 (a .7) · 4 · 0,78 · 0,44 · 26 (a .8) |
| horizonte | 3 · −0,36 · 0,47 · 78 · 6 · 0,04 · 0,56 · 150 · 1 · 0,52 · 0,50 · 110 (e) |
| frente | 6 · −0,30 · 0,62 · 160 (e) · 3 · 0,56 · 0,60 · 82 (e) · 1 · 0,20 · 0,74 · 170 · 4 · −0,20 · 0,86 · 80 · 7 · 0,70 · 0,94 · 50 |
| muro | 3 · −0,40 · 0,14 · 150 · 4 · 0,45 · 0,12 · 110 (e) · 6 · −1,00 · 0,38 · 320 (e) · 1 · −0,30 · 0,44 · 280 · 3 · 0,10 · 0,62 · 170 (e) · 6 · −0,60 · 0,76 · 330 |

A sombra de nuvem (`.sombra`, atrás do texto) é uma camada própria, parada e do tamanho do palco, entre a camada da frente e o muro; a caixa de fora (`.sombra-in`) entra com as nuvens da frente (GSAP) e a de dentro some na saída (`palco.js`). Dentro da camada da frente ela subiria e a borda de baixo viraria uma faixa reta.

Faixas de névoa (gradiente vertical, `left/right: −10%`): horizonte de 64% (58% no celular) até `bottom: −200%`, chegando a `rgba(232,214,196,.95)`; frente de 80% até `bottom: −300%`, chegando a `rgba(232,216,200,.85)`; muro de 74% até `bottom: −200%`, creme 2 cheio. A ponta de baixo fica sempre fora da tela, mesmo com a frente subindo 1,25 altura e crescendo 38%.
Serra: `mask-image: linear-gradient(180deg, #000 30%, transparent 92%)`.
Filtros: longe `saturate(.78) brightness(1.03) contrast(.86)`; horizonte `saturate(.9) contrast(.92)`; muro `brightness(1.07) saturate(.85)`.

## Palco — números
- Hero com 200svh (185svh no celular); palco `position: sticky; top: 0; height: 100svh; overflow: hidden`.
- `p = scrollY / (alturaDoHero − innerHeight)`, limitado a 0..1 e suavizado (16% por quadro a 60 fps, corrigido pelo tempo do quadro).
- Por camada: `translate3d(−mx·26·prof, −my·14·prof − p·saída·A, 0) scale(1 + p·escala)`.
  | camada | prof | saída | escala | origem |
  |---|---|---|---|---|
  | céu | 0,05 | 0,06 | — | |
  | longe | 0,18 | 0,16 | — | |
  | horizonte | 0,34 | 0,32 | — | |
  | ilha | 0,58 | 0,6 | −0,14 | 51,5% 40% |
  | frente | 1 | 1,25 | +0,38 | 50% 85% |
- Muro: `translate3d(−mx·26·1,3, (1,16 − 1,62·p)·A, 0)`; começa em `translateY(120%)` no CSS (invisível antes do JS).
- Véu: opacidade `smoothstep(.5, .9, p)`. Fechamento com `margin-top: -45svh` e um `::before` de 45svh acima dele (gradiente transparente → creme 2), sem isso no movimento reduzido. Sombra de nuvem: `1 − smoothstep(.02, .3, p)`. Ilha (opacidade da camada): `1 − smoothstep(.28, .58, p)`. Texto: sobe `p·0,62·A`, opacidade `1 − smoothstep(.02, .3, p)`, `visibility: hidden` acima de 0,32. HUD: `1 − smoothstep(0, .22, p)`. Nav tinta cheia acima de 0,82. Nav some ao descer (> 4 px de diferença, abaixo de 40 px de scroll ela sempre aparece) e volta ao subir ou ao receber foco: `translate(-50%, calc(-100% - 24px))` + opacidade 0, transição de 0,6 s.
- Só escreva estilos quando cursor, `p` ou altura mudarem (compare uma chave com os valores arredondados).

## Entrada — tempos (GSAP, `expo.out` salvo indicação)
céu 0 s (1,4 s, `power2.inOut`) · longe 0,3 s (de y 40) · horizonte 0,45 s (de y 70) · ilha 0,6 s (de y 0,2·A e escala 0,94, 2,8 s, `power3.out`) · frente 0,8 s (de y 130) · letras 1,15 s (`yPercent` 115 → 0, 1,4 s, 65 ms entre letras) · nav e HUD 1,3 s · contagem do HUD 1,3 s (1,9 s, `power2.out`) · linhas do texto 1,4 s · asterisco 1,55 s (de escala 0 e −140°) · botão 1,7 s · dica 2,3 s.
Estado inicial aplicado antes do primeiro quadro (`gsap.set`), senão a cena pisca pronta antes de entrar.

## Regras de qualidade
- Mobile tão cuidado quanto desktop; nada de rolagem horizontal.
- Ilha com `fetchpriority="high"` e `preload`. As nuvens são pequenas (13–47 KB).
- Só `transform` e `opacity` por quadro. Filtros (desfoque, tom) fixos em cada imagem, nunca animados.
- Marca fictícia: não invente selos, prêmios, depoimentos nem CNPJ.

## Como conferir
1. `npm run build` sem erro; console limpo.
2. Prints headless (Playwright, Chromium) em 1456×840 e 390×844, depois de ~5 s (fim da entrada): hero inteiro; saída em `p` 0,30 e 0,62 (desktop) e 0,45 (celular), esperando ~1,8 s depois de rolar (a suavização); fechamento.
3. Na saída (15, 30, 45, 62 e 80% no desktop, 45% no celular), amplie com `page.screenshot({ clip })` e procure **linha reta horizontal** e **pedacinho solto**. Linha reta = alguma camada terminando na tela (veja a regra 2); pedacinho = alfa sujo na imagem ou a ilha ainda visível entre as nuvens.
4. Recorte o parágrafo do hero no print e confira que dá para ler sobre a parte mais clara das nuvens.
5. Ligue "reduzir movimento" e confira que o hero fica parado, inteiro e legível.
