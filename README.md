# Blog / Portfólio — Henrique Freire

Blog técnico  inspirado no tutorial https://aleatorio.dev.br/posts/blog-github-pages/, construído com [Jekyll](https://jekyllrb.com/) + tema
[Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy), publicado via
GitHub Pages. Ambiente de desenvolvimento isolado com [Nix](https://nixos.org/).

Duas linhas de conteúdo:
- **`/tecnico`** — posts didáticos sobre conteúdos técnicos de radiologia.
- **`/experiencias`** — relatos de vivências, estágios, aprendizados (formato
  parecido com um post de LinkedIn).

---

## 1. Pré-requisitos

- [Nix](https://nixos.org/download) instalado.
- Git instalado.
- Conta no GitHub.

Não é necessário instalar Ruby, Bundler ou Jekyll manualmente — tudo isso é
fornecido pelo ambiente Nix definido em `shell.nix`.

---

## 2. Configurar o ambiente local

Na raiz do repositório (onde está o `shell.nix`):

```bash
nix-shell
```

Isso abre um shell com Ruby, Bundler e as ferramentas de build necessárias
já fixadas (pinadas) em uma versão específica do nixpkgs, evitando problemas
de "funciona na minha máquina, mas não na sua".

**Na primeira vez**, dentro do `nix-shell`, instale as gems do projeto
(Jekyll, plugins do Chirpy, etc.), definidas no `Gemfile`:

```bash
bundle install
```

Isso vai gerar um arquivo `Gemfile.lock` — ele *deve* ser commitado junto
com o repositório, pois garante que todo mundo (e o GitHub Actions, na
hora de publicar) use exatamente as mesmas versões de gems.

> Se aparecer o erro `Could not locate Gemfile`, você está na pasta errada,
> ou o tema ainda não foi clonado para dentro dela.

---

## 3. Rodar o blog localmente

Ainda dentro do `nix-shell`:

```bash
bundle exec jekyll serve
```

O terminal vai mostrar algo como:

```
Server address: http://127.0.0.1:4000
Server running... press ctrl-c to stop.
```

Abra esse endereço no navegador. O Jekyll **reconstrói automaticamente**
quando você salva alterações em arquivos `.md` ou no `_config.yml` (para
mudanças no `_config.yml`, em geral é necessário parar com `Ctrl+C` e rodar
o `jekyll serve` de novo).

---

## 4. Configurar o `_config.yml`

Antes de publicar, revise o arquivo `_config.yml` na raiz. Pontos que
precisam dos seus dados:

| Campo | O que fazer |
|---|---|
| `url` | URL final do site, ex: `https://henriquefreire.github.io` |
| `github.username` | Seu usuário no GitHub |
| `social.email` | Seu e-mail público de contato |
| `social.links` | Links do rodapé (GitHub, LinkedIn, etc.) |
| `avatar` | Caminho para sua foto (ver seção 6) |
| `comments.giscus` | Ver seção 7 — só pode ser preenchido depois do repositório estar no GitHub |

Depois de editar, salve e veja o resultado no `localhost:4000` (reinicie o
`jekyll serve` se necessário).

---

## 5. Criar um novo post

Posts ficam na pasta `_posts/`, e o **nome do arquivo segue um padrão
obrigatório**:

```
AAAA-MM-DD-titulo-curto-do-post.md
```

Exemplo, para um post técnico sobre radiação:

```bash
touch _posts/2026-06-21-principios-basicos-de-atenuacao.md
```

Abra o arquivo e comece com o **front matter** (bloco de configuração no
topo, em YAML, entre `---`):

```markdown
---
title: "Princípios básicos de atenuação da radiação"
date: 2026-06-21 10:00:00 -0300
categories: [Técnico, Radioproteção]
tags: [radiação, fisica, teoria]
---

Texto do post aqui, em Markdown normal.

## Subtítulo

Você pode usar **negrito**, *itálico*, listas, imagens e links normalmente.

![Diagrama de atenuação](/assets/img/posts/atenuacao-diagrama.png)

Veja a aplicação prática disso no [simulador de radiação](https://henriquefreire.github.io/Simulador-de-radiacao-POC/).
```

Para um post de **experiência** (estilo relato), o front matter muda só nas
categorias/tags:

```markdown
---
title: "Minha primeira semana de estágio em tomografia"
date: 2026-06-22 09:00:00 -0300
categories: [Experiências, Estágio]
tags: [estagio, tomografia, vivencia]
---

Relato em primeira pessoa aqui...
```

### Campos importantes do front matter

- `title`: aparece como título do post e na aba do navegador.
- `date`: define a ordem cronológica e a URL do post. **Tem que bater** com
  a data no nome do arquivo (ano-mês-dia).
- `categories`: usado para agrupar posts (vira parte da navegação por
  categoria do tema).
- `tags`: palavras-chave, aparecem na página de tags.

### Adicionando imagens

Coloque a imagem em `assets/img/posts/` (crie a pasta se não existir) e
referencie com caminho absoluto a partir da raiz do site:

```markdown
![Descrição da imagem](/assets/img/posts/nome-da-imagem.png)
```

### Rascunhos (não publicados ainda)

Se quiser escrever um post sem publicar ainda, coloque em `_drafts/` (sem a
data no nome do arquivo) e rode o Jekyll com a flag de rascunhos:

```bash
bundle exec jekyll serve --drafts
```

---

## 6. Trocar o avatar

1. Coloque sua foto em `assets/img/commons/avatar.jpg` (ou outro nome).
2. No `_config.yml`, ajuste:
   ```yaml
   avatar: "/assets/img/commons/avatar.jpg"
   ```
3. Reinicie o `jekyll serve` para ver a mudança.

---

## 7. Ativar comentários (Giscus)

Os comentários usam o GitHub Discussions como backend — só funciona depois
que o repositório estiver publicado no GitHub.

1. Suba o repositório para o GitHub (seção 8).
2. No repositório, vá em **Settings → General → Features** e ative
   **Discussions**.
3. Acesse [giscus.app](https://giscus.app), cole a URL do seu repositório e
   siga as instruções da página — ela vai gerar os valores `repo_id` e
   `category_id`.
4. Cole esses valores no `_config.yml`, na seção `comments.giscus`.

---

## 8. Publicar no GitHub Pages

Depois de revisar tudo localmente:

```bash
git add .
git commit -m "Configura blog com dados pessoais e primeiro post"
git push origin main
```

Como o Chirpy usa plugins que o build nativo do GitHub Pages não suporta,
a publicação é feita via **GitHub Actions** (o workflow já vem definido em
`.github/workflows/` no próprio tema). Após o push:

1. Vá em **Settings → Pages** no repositório, no GitHub.
2. Em **Build and deployment → Source**, selecione **GitHub Actions**.
3. Vá na aba **Actions** do repositório e acompanhe o workflow rodando.
4. Quando terminar com sucesso, o site estará disponível em
   `https://henriquefreire.github.io`.

---

## Resumo dos comandos do dia a dia

```bash
nix-shell                      # entra no ambiente de desenvolvimento
bundle exec jekyll serve       # roda o blog localmente em localhost:4000
bundle exec jekyll serve --drafts  # inclui posts em _drafts/
```