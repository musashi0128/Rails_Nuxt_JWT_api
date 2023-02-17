
# FROMは、ベースイメージの指定
FROM ruby:2.7.2-alpine

# ARGは、Dockerfile内で使用する変数名を指定します。
# appが入っている
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# ENVは、Dockerイメージで使用する環境変数を指定します。
ENV HOME=/${WORKDIR} \
  LANG=C.UTF-8 \
  TZ=Asia/Tokyo

# WORKDIRは、Dockerfileで定義した命令を実行する、コンテナ内の作業ディレクトリパスを指定します。 ... RUN, COPY, ADD, ENTORYPOINT, CMD
WORKDIR ${HOME}

# COPYは、ローカルファイルをイメージにコピーする命令です。(ローカルファイルとは自分のPC上にあるファイルです。)
COPY Gemfile* ./

# RUNは、ベースイメージに対して何らかのコマンドを実行する場合に使用します。
# $HOME -> /app

#apk update = 利用可能なパッケージの最新リストを取得するためのコマンドです。
RUN apk update && \
  # apk upgrade = インストールされているパッケージをアップグレードします。
  apk upgrade && \
  #apk add = パッケージをインストールするコマンドです。 / --no-casheオプション = ローカルにキャッシュしないようにする、addコマンドのオプションです。
  apk add --no-cache ${RUNTIME_PACKAGES} && \
  # --virtualオプション <名前> = addコマンドのオプションです。、このオプションを付けてインストールしたパッケージは、一まとめにされ、新たなパッケージとして扱うことができます。
  apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
  # bundle install -j4 = Railsに必要なGemをインストールするためにbundle installコマンドを実行しています。 / -j4はGemインストールの高速化
  bundle install -j4 && \
  # apk del = パッケージを削除するコマンドです。Dockeイメージの軽量化
  # apk addでまとめてインストールしたので最後に削除する
  apk del build-dependencies

# COPY . ./は、Dockerファイルのある(サブディレも含め)全てのファイルをイメージにコピーしています。(それぞれ相対パスで指定しています。)
COPY . ./

# CMDは、生成されたコンテナ内で実行したいコマンドを指定します。
# CMD ["rails", "server", "-b", "0.0.0.0"]