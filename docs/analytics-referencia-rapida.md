# Analytics - Referência Rápida

## 🚀 Setup Inicial

```dart
import 'package:divide_ai/services/analytics_service.dart';
```

## 📋 Métodos Disponíveis

### Método Principal
```dart
AnalyticsService.trackEvent(
  elementId: 'nome_elemento',
  eventType: 'CLICK|PAGE_VIEW|LOADING',
  page: 'nome_pagina',
  loading: 1234567890, // opcional
);
```

### Métodos Específicos
```dart
// Botões
AnalyticsService.trackButtonClick('texto_botao', 'pagina');

// Páginas
AnalyticsService.trackPageView('pagina');  // Sem tempo de carregamento
AnalyticsService.trackPageLoading('pagina', tempoCarregamento);  // Com tempo de carregamento

// Cards
AnalyticsService.trackCardClick('nome_card', 'pagina');

// Inputs
AnalyticsService.trackInputFocus('label_input', 'pagina');

// Navegação
AnalyticsService.trackNavigation('origem', 'destino');
```

## 🎯 Templates Prontos

### Nova Página
```dart
class MinhaScreen extends StatefulWidget {
  @override
  State<MinhaScreen> createState() => _MinhaScreenState();
}

class _MinhaScreenState extends State<MinhaScreen> {
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
      AnalyticsService.trackPageView('minha_screen', loadTime);
      AnalyticsService.trackPageLoading('minha_screen', loadTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(/* conteúdo */);
  }
}
```

### Botão Customizado
```dart
ElevatedButton(
  onPressed: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'pagina_atual';
    AnalyticsService.trackButtonClick('meu_botao', pageName);
    
    // Sua ação aqui
  },
  child: Text('Meu Botão'),
)
```

### Card Clicável
```dart
InkWell(
  onTap: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'pagina_atual';
    AnalyticsService.trackEvent(
      elementId: 'meu_card',
      eventType: 'CLICK',
      page: pageName,
    );
    
    // Sua ação aqui
  },
  child: Card(/* conteúdo */),
)
```

### Input Customizado
```dart
TextField(
  onTap: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'pagina_atual';
    AnalyticsService.trackEvent(
      elementId: 'meu_input',
      eventType: 'CLICK',
      page: pageName,
    );
  },
  // outras propriedades
)
```

## 📝 Regras de Nomenclatura

### ElementId
- **Formato**: `snake_case`
- **Exemplos**: `adicionar_despesa`, `salvar_dados`, `card_grupo`

### Page
- **Formato**: `snake_case` + `_screen`
- **Exemplos**: `home_screen`, `perfil_screen`, `configuracoes_screen`

## ✅ Componentes com Tracking Automático

**NÃO precisa implementar** nos seguintes componentes:
- `Button` (todos os tipos)
- `Input` (todos os tipos)
- `GroupCard`
- Telas: `HomeGroupScreen`, `TransactionsGroupScreen`, `CreateTransactionScreen`

## 🔧 Obter Nome da Página Atual

```dart
final route = ModalRoute.of(context);
final pageName = route?.settings.name ?? 'nome_fallback';
```

## 📊 Payload Enviado para API

```json
{
  "elementId": "adicionar_despesa",
  "variant": "A",
  "eventType": "CLICK",
  "page": "transactions_screen",
  "loading": 1703123456789
}
```

## 🎯 Casos de Uso Comuns

### Dialog/Modal
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    actions: [
      TextButton(
        onPressed: () {
          AnalyticsService.trackEvent(
            elementId: 'dialog_confirmar',
            eventType: 'CLICK',
            page: 'dialog_confirmacao',
          );
          Navigator.pop(context);
        },
        child: Text('Confirmar'),
      ),
    ],
  ),
);
```

### Lista de Itens
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      onTap: () {
        AnalyticsService.trackEvent(
          elementId: 'item_lista_$index',
          eventType: 'CLICK',
          page: 'lista_screen',
        );
      },
    );
  },
)
```

### Navegação
```dart
void navegarPara(BuildContext context, Widget destino) {
  final route = ModalRoute.of(context);
  final origem = route?.settings.name ?? 'unknown';
  
  AnalyticsService.trackNavigation(origem, 'destino_screen');
  
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destino),
  );
}
```

## ⚠️ Checklist

- [ ] Importei o `AnalyticsService`?
- [ ] Usei nomenclatura `snake_case`?
- [ ] Testei em ambiente de desenvolvimento?
- [ ] Verifiquei se o componente já tem tracking automático?
- [ ] Documentei novos padrões criados?

## 🔗 Links Úteis

- **Serviço Principal**: `lib/services/analytics_service.dart`
- **Guia Completo**: `docs/como-implementar-analytics.md`
- **Exemplos Existentes**: Veja componentes `Button`, `Input`, `GroupCard`

---

💡 **Dica**: Sempre teste primeiro em desenvolvimento antes de fazer deploy!
