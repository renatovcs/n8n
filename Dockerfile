# Estágio 1: Build da Aplicação em um ambiente Debian completo
FROM node:22

# Define o diretório de trabalho
WORKDIR /app

# Instala o pnpm
RUN npm install -g pnpm

# Copia todos os arquivos de manifesto e de código necessários para a instalação
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY packages/ ./packages/
COPY patches/ ./patches/

# Instala as dependências de forma compatível, ignorando scripts e otimizando a estrutura
RUN pnpm install --ignore-scripts --shamefully-hoist

# Copia o resto do código-fonte
COPY . .

# Constrói a aplicação com memória aumentada
RUN NODE_OPTIONS="--max-old-space-size=8192" pnpm run build

# Expõe a porta do n8n
EXPOSE 5678

# Define um usuário não-root por segurança
USER node

# Comando final para iniciar a aplicação
CMD [ "pnpm", "start" ]