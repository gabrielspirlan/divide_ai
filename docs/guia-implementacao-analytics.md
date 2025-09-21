# Guia de Implementação - Sistema de Analytics

Este documento explica como implementar o sistema de rastreamento de eventos (analytics) em novos componentes e telas do projeto Flutter.

## 📋 Visão Geral

O sistema de analytics rastreia três tipos principais de eventos:
- **CLICK**: Interações do usuário (botões, cards, inputs)
- **PAGE_VIEW**: Visualizações de tela
- **LOADING**: Tempos de carregamento de páginas

## 🔧 Configuração Inicial

### 1. Importar o Serviço
```dart
import 'package:divide_ai/services/analytics_service.dart';
```

### 2. Estrutura do Payload
```json
{
  "elementId": "nome_do_componente",
  "variant": "A",
  "eventType": "CLICK|PAGE_VIEW|LOADING",
  "page": "nome_da_pagina",
  "loading": 1234567890
}
```

## 🎯 Implementação por Tipo de Componente

### 📱 **Novas Telas/Screens**

#### Rastreamento de PAGE_VIEW e LOADING:

```dart
class MinhaNovaScreenState extends State<MinhaNovaScreen> {
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackPageLoad();
    });
  }

  void _trackPageLoad() {
    final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
    AnalyticsService.trackPageView('minha_nova_screen', loadTime);
    AnalyticsService.trackPageLoading('minha_nova_screen', loadTime);
  }

  @override
  Widget build(BuildContext context) {
    // Seu código da tela aqui
  }
}
```

### 🔘 **Botões Personalizados**

Os botões que usam o componente `Button` já têm tracking automático. Para botões customizados:

```dart
ElevatedButton(
  onPressed: () {
    // Rastrear clique
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackButtonClick('nome_do_botao', pageName);
    
    // Sua lógica do botão aqui
    minhaFuncao();
  },
  child: Text('Meu Botão'),
)
```

### 🃏 **Cards Clicáveis**

```dart
InkWell(
  onTap: () {
    // Rastrear clique no card
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackEvent(
      elementId: 'nome_do_card',
      eventType: 'CLICK',
      page: pageName,
    );
    
    // Sua lógica do card aqui
    navegarParaOutraTela();
  },
  child: Card(
    // Conteúdo do card
  ),
)
```

### 📝 **Campos de Input**

Os inputs que usam o componente `Input` já têm tracking automático. Para inputs customizados:

```dart
TextField(
  focusNode: _focusNode,
  onTap: () {
    // Rastrear foco no input
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackEvent(
      elementId: 'nome_do_input',
      eventType: 'CLICK',
      page: pageName,
    );
  },
  // Outras propriedades do TextField
)
```

## 🛠️ Métodos Disponíveis no AnalyticsService

### Métodos Principais:
```dart
// Método genérico para qualquer evento
AnalyticsService.trackEvent(
  elementId: 'nome_elemento',
  eventType: 'CLICK|PAGE_VIEW|LOADING',
  page: 'nome_pagina',
  loading: 1234567890, // opcional
);

// Métodos específicos
AnalyticsService.trackButtonClick('texto_botao', 'nome_pagina');
AnalyticsService.trackPageView('nome_pagina', tempoCarregamento);
AnalyticsService.trackPageLoading('nome_pagina', tempoCarregamento);
AnalyticsService.trackCardClick('nome_card', 'nome_pagina');
AnalyticsService.trackInputFocus('label_input', 'nome_pagina');
AnalyticsService.trackNavigation('pagina_origem', 'pagina_destino');
```

## 📏 Convenções de Nomenclatura

### ElementId:
- **Formato**: `nome_do_elemento` (snake_case)
- **Exemplos**: 
  - `adicionar_gasto` (botão)
  - `bahia_lanches` (card de grupo)
  - `nome_da_despesa` (input)
  - `home_group_screen` (página)

### Page:
- **Formato**: `nome_da_screen` (snake_case)
- **Exemplos**:
  - `home_group_screen`
  - `transactions_group_screen`
  - `create_transaction_screen`

## ⚠️ Boas Práticas

### 1. **Nomes Descritivos**
```dart
// ✅ Bom
AnalyticsService.trackButtonClick('adicionar_gasto', 'transactions_screen');

// ❌ Ruim
AnalyticsService.trackButtonClick('btn1', 'screen');
```

### 2. **Tratamento de Erros**
O serviço já trata erros automaticamente, mas você pode adicionar logs extras:

```dart
try {
  AnalyticsService.trackButtonClick('meu_botao', 'minha_tela');
} catch (e) {
  debugPrint('Erro no tracking: $e');
}
```

### 3. **Performance**
- Os eventos são enviados de forma assíncrona
- Não bloqueiam a interface do usuário
- Falhas de rede não afetam a funcionalidade do app

## 🔍 Exemplos Práticos

### Exemplo 1: Nova Tela de Configurações
```dart
class ConfiguracoesScreen extends StatefulWidget {
  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
      AnalyticsService.trackPageView('configuracoes_screen', loadTime);
      AnalyticsService.trackPageLoading('configuracoes_screen', loadTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Column(
        children: [
          Button(
            text: 'Salvar Configurações',
            onPressed: () {
              // O tracking já é automático para o componente Button
              salvarConfiguracoes();
            },
          ),
        ],
      ),
    );
  }
}
```

### Exemplo 2: Card Personalizado
```dart
class MeuCardPersonalizado extends StatelessWidget {
  final String titulo;
  final VoidCallback onTap;

  const MeuCardPersonalizado({
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = ModalRoute.of(context);
        final pageName = route?.settings.name ?? 'unknown_page';
        AnalyticsService.trackEvent(
          elementId: titulo.toLowerCase().replaceAll(' ', '_'),
          eventType: 'CLICK',
          page: pageName,
        );
        onTap();
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(titulo),
        ),
      ),
    );
  }
}
```

## 🚀 Próximos Passos

1. **Teste a implementação** em ambiente de desenvolvimento
2. **Verifique os logs** para confirmar que os eventos estão sendo enviados
3. **Monitore a API** para validar que os dados chegam corretamente
4. **Documente novos componentes** seguindo este guia

## 📞 Suporte

Para dúvidas sobre implementação, consulte:
- Este documento
- Código existente nos componentes já implementados
- Serviço `AnalyticsService` em `lib/services/analytics_service.dart`
