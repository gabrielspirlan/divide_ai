# 💰 Divide Aí

**Aplicativo inteligente para divisão de gastos entre amigos**

O Divide Aí é um aplicativo Flutter que facilita a divisão de contas quando você sai com amigos. Acabou a dor de cabeça de calcular quem deve quanto no final do jantar! 🍽️

## 🎯 Problema que Resolve

Quando um grupo de amigos vai jantar e pede tudo em uma única comanda, sempre surge aquela situação constrangedora no final:
- "Quem pediu o que?"
- "Quanto cada um deve pagar?"
- "Como dividir os itens compartilhados?"

O Divide Aí resolve isso permitindo que você registre os gastos em tempo real, evitando confusões e cálculos demorados na hora de pagar a conta.

## ✨ Funcionalidades

### 🏠 **Tela Principal (Home)**
- Visualização de todos os grupos de gastos
- Cards informativos com valor total e participantes
- Acesso rápido aos detalhes de cada grupo

### 📝 **Gerenciamento de Transações**
- Registro de itens individuais e compartilhados
- Seleção de participantes para cada item
- Histórico completo de todas as transações do grupo

### 💳 **Divisão Automática da Conta**
- Cálculo automático do valor que cada pessoa deve pagar
- Separação entre gastos individuais e compartilhados
- Visualização clara e detalhada da divisão

### 👥 **Gestão de Grupos**
- Criação de grupos para diferentes ocasiões
- Adição/remoção de participantes
- Histórico de grupos anteriores

## 🚀 Como Usar

1. **Crie um grupo** para a ocasião (ex: "Jantar no Restaurante X")
2. **Adicione os participantes** que estão presentes
3. **Registre cada item** conforme for pedindo:
   - Marque se é individual ou compartilhado
   - Selecione quem participou do item
4. **Visualize a divisão** automática na tela de conta
5. **Cada um paga sua parte** sem complicações!

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework principal
- **Dart** - Linguagem de programação
- **Material Design** - Interface do usuário
- **Google Fonts** - Tipografia
- **Font Awesome & HugeIcons** - Ícones
- **HTTP** - Comunicação com API
- **Intl** - Formatação de moeda e datas

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🏗️ Arquitetura do Projeto

```
lib/
├── components/          # Componentes reutilizáveis
│   ├── group/          # Componentes específicos de grupos
│   ├── transaction/    # Componentes de transações
│   ├── ui/            # Componentes de interface
│   └── users/         # Componentes de usuários
├── models/            # Modelos de dados
│   ├── components/    # Modelos de componentes
│   ├── data/         # Modelos de dados principais
│   └── enums/        # Enumerações
├── screens/          # Telas do aplicativo
├── services/         # Serviços (API, Analytics)
└── theme/           # Configurações de tema
```

## 📊 Analytics e Monitoramento

O aplicativo inclui um sistema completo de analytics que rastreia:
- **Interações do usuário** (cliques, navegação)
- **Visualizações de tela** (page views)
- **Performance** (tempos de carregamento)

## 🎨 Design System

- **Tema escuro** como padrão
- **Cores consistentes** em todo o app
- **Componentes padronizados** (botões, cards, inputs)
- **Tipografia** otimizada com Google Fonts
- **Ícones** modernos e intuitivos

## 💡 Exemplos de Uso

### Cenário 1: Lanchonete
```
Grupo: "Bahia Lanches"
Participantes: Luiz, Gabriel, Henrique, Felipe

Itens:
- X-Tudão (R$ 29,00) → Luiz
- X-Franca (R$ 32,90) → Gabriel
- X-Basqueste (R$ 35,50) → Henrique
- X-Tudão (R$ 29,00) → Felipe
- Coca-Cola 2L (R$ 10,00) → Todos (compartilhado)
- Batata Cheddar (R$ 24,00) → Todos (compartilhado)

Resultado automático:
- Luiz: R$ 37,50 (29 + 8,50 compartilhado)
- Gabriel: R$ 41,40 (32,90 + 8,50 compartilhado)
- Henrique: R$ 44,00 (35,50 + 8,50 compartilhado)
- Felipe: R$ 37,50 (29 + 8,50 compartilhado)
```

### Cenário 2: Espetinho
```
Grupo: "Espetinho da Fatec"
Participantes: Luiz, Gabriel, Henrique, Felipe

Itens:
- Coca-Cola 2L (R$ 15,00) → Todos (compartilhado)
- Espetinho Carne (R$ 10,00) → Gabriel
- Espetinho Medalhão (R$ 10,00) → Felipe
- Espetinho Medalhão (R$ 10,00) → Luiz
- Espetinho Coração (R$ 10,00) → Henrique

Resultado automático:
- Luiz: R$ 13,75 (10 + 3,75 compartilhado)
- Gabriel: R$ 13,75 (10 + 3,75 compartilhado)
- Henrique: R$ 13,75 (10 + 3,75 compartilhado)
- Felipe: R$ 13,75 (10 + 3,75 compartilhado)
```

## 🚀 Instalação e Configuração

### Pré-requisitos

- **Flutter SDK** (versão 3.8.1 ou superior)
- **Dart SDK** (incluído com Flutter)
- **Android Studio** ou **VS Code** com extensões Flutter
- **Git** para controle de versão

### Passos para Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/divide_ai.git
   cd divide_ai
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o arquivo de ambiente (.env)**

   O aplicativo utiliza variáveis de ambiente para configurar a URL da API. Siga os passos abaixo:

   a. **Copie o arquivo de exemplo**
   ```bash
   cp .env.example .env
   ```

   b. **Edite o arquivo `.env`** e configure a URL da API:
   ```env
   DIVIDE_AI_BASE_URL=https://divide-ai-api-i8en.onrender.com
   ```

   > **📌 Nota:** A URL padrão já está configurada para apontar para a API em produção. Se você estiver rodando a API localmente, altere para `http://localhost:8080` ou a porta que estiver utilizando.

4. **Execute o aplicativo**
   ```bash
   # Para desenvolvimento (modo debug)
   flutter run

   # Para Android
   flutter run -d android

   # Para iOS
   flutter run -d ios

   # Para Web
   flutter run -d chrome
   ```

### Configuração do Ambiente

1. **Verifique se o Flutter está configurado corretamente**
   ```bash
   flutter doctor
   ```

2. **Para Android**: Configure o Android SDK e aceite as licenças
   ```bash
   flutter doctor --android-licenses
   ```

3. **Para iOS**: Instale o Xcode e configure as ferramentas de desenvolvimento

## 🔌 API Backend

O Divide Aí utiliza uma API REST desenvolvida em **Spring Boot (Java)** para gerenciar todos os dados do aplicativo.

### 📚 Repositório da API

- **GitHub:** [https://github.com/gabrielspirlan/divide_ai_api](https://github.com/gabrielspirlan/divide_ai_api)

### 📖 Documentação da API (Swagger)

A API possui documentação completa e interativa gerada com **SpringDoc OpenAPI (Swagger 3.0)**.

- **URL da Documentação:** [https://divide-ai-api-i8en.onrender.com/swagger](https://divide-ai-api-i8en.onrender.com/swagger)

Através da documentação Swagger você pode:
- ✅ Visualizar todos os endpoints disponíveis
- ✅ Testar as requisições diretamente no navegador
- ✅ Ver exemplos de requisições e respostas
- ✅ Entender os modelos de dados utilizados
- ✅ Verificar os códigos de status HTTP retornados

### 🌐 Endpoints Principais

A API oferece os seguintes recursos:

- **Autenticação** (`/auth`)
  - Login e registro de usuários
  - Gerenciamento de tokens JWT

- **Usuários** (`/users`)
  - CRUD de usuários
  - Consulta de perfil

- **Grupos** (`/groups`)
  - Criação e gerenciamento de grupos
  - Adição/remoção de participantes
  - Consulta de divisão de contas

- **Transações** (`/transactions`)
  - Registro de despesas
  - Consulta de histórico
  - Cálculo automático de divisão

### 🔐 Autenticação

A API utiliza **JWT (JSON Web Token)** para autenticação. O aplicativo gerencia automaticamente:
- Armazenamento seguro do token
- Inclusão do token em todas as requisições autenticadas
- Renovação automática quando necessário
- Logout e limpeza de sessão

## 🧪 Executando Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Executar testes específicos
flutter test test/analytics_service_test.dart
```

## 📦 Build para Produção

### Android (APK)
```bash
flutter build apk --release
```

### Android (App Bundle)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribuindo

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Padrões de Código

- Siga as convenções do **Dart/Flutter**
- Use **flutter_lints** para análise estática
- Mantenha **cobertura de testes** acima de 80%
- Documente **funções públicas**
- Use **nomes descritivos** para variáveis e funções

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👥 Equipe de Desenvolvimento

- **Luiz Felipe Vieira Soares**
- **Gabriel Resende Spirlandelli**
- **Henrique Almeida Florentino**
- **Felipe Avelino Pedaes**


![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

**Desenvolvido com ❤️ pela equipe Divide Aí**

*Simplifique suas saídas com amigos - use o Divide Aí!* 🎉
