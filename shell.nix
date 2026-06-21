# shell.nix
#
# Ambiente de desenvolvimento para o blog Jekyll (GitHub Pages).
# Uso:
#   1. Instale o Nix (https://nixos.org/download) se ainda não tiver.
#   2. Na raiz do repositório (onde está este arquivo), rode: nix-shell
#   3. Dentro do shell, instale as gems do tema:        bundle install
#   4. Rode o servidor local:                            bundle exec jekyll serve
#   5. Acesse no navegador:                              http://localhost:4000
#
# O servidor fica "vivo" e recarrega automaticamente quando você salva
# um post novo ou edita o _config.yml (em geral precisa restartar pra
# mudanças no _config.yml).

{
  # Pin do nixpkgs em um commit fixo (branch nixos-24.05), pra garantir que
  # o ambiente seja sempre o mesmo, independente do que estiver no channel
  # local de quem rodar isso. Sem isso, pacotes podem ser removidos/trocados
  # de versão silenciosamente (foi o que causou o erro do ruby_3_2 acima).
  #
  # Pra atualizar o pin no futuro: pegue um commit recente de
  # https://github.com/NixOS/nixpkgs/commits/nixos-24.05 e troque o rev
  # e o sha256 abaixo (o nix avisa o sha256 certo se você colocar um
  # placeholder errado e rodar).
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";
    # IMPORTANTE: o sha256 abaixo é um placeholder. Rode estes dois comandos
    # uma vez pra pegar o hash real desse tarball e cole o valor aqui:
    #
    #   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/24.05.tar.gz
    #
    # O comando imprime um hash em base32. Cole ele no lugar do placeholder.
    # Se você rodar o nix-shell com o placeholder errado, o próprio Nix vai
    # te dizer qual é o hash correto na mensagem de erro (got: sha256-...).
    sha256 = "1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
  }) {}
}:

pkgs.mkShell {
  name = "jekyll-blog-env";

  buildInputs = [
    pkgs.ruby     # versão estável fixada pelo pin do nixpkgs (24.05)
    pkgs.bundler
    pkgs.gcc          # necessário pra compilar algumas gems nativas (ex: nokogiri)
    pkgs.gnumake
    pkgs.pkg-config
    pkgs.libffi
    pkgs.zlib
  ];

  shellHook = ''
    echo "Ambiente Jekyll pronto."
    echo "Se for a primeira vez: bundle install"
    echo "Depois:                bundle exec jekyll serve"
    export GEM_HOME="$PWD/.gem"
    export PATH="$GEM_HOME/bin:$PATH"
  '';
}
