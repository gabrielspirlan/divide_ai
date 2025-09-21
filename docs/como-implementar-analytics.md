# Como Implementar Analytics em Novos Componentes

Este guia prático mostra como adicionar rastreamento de eventos em novos componentes e páginas do projeto Flutter.

## 📋 Tipos de Eventos Suportados

| Tipo | Descrição | Quando Usar |
|------|-----------|-------------|
| `CLICK` | Interações do usuário | Botões, cards, links, menus |
| `PAGE_VIEW` | Visualização de tela | Quando uma tela é exibida |
| `LOADING` | Tempo de carregamento | Medição de performance de telas |

## 🚀 Implementação Rápida

### 1️⃣ **Para Novas Páginas/Telas**

```dart
import 'package:divide_ai/services/analytics_service.dart';

class MinhaNovaScreen extends StatefulWidget {
  @override
  State<MinhaNovaScreen> createState() => _MinhaNovaScreenState();
}

class _MinhaNovaScreenState extends State<MinhaNovaScreen> {
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
    return Scaffold(
      // Seu conteúdo aqui
    );
  }
}
```

### 2️⃣ **Para Botões Customizados**

```dart
// Botões que usam o componente Button já têm tracking automático!
Button(
  text: "Meu Botão",
  onPressed: () {
    // Tracking automático já aplicado
    minhaFuncao();
  },
)

// Para botões customizados:
ElevatedButton(
  onPressed: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackButtonClick('meu_botao_customizado', pageName);
    
    minhaFuncao();
  },
  child: Text('Botão Customizado'),
)
```

### 3️⃣ **Para Cards Clicáveis**

```dart
InkWell(
  onTap: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackEvent(
      elementId: 'meu_card_especial',
      eventType: 'CLICK',
      page: pageName,
    );
    
    // Sua ação aqui
    navegarParaOutraTela();
  },
  child: Card(
    child: Text('Meu Card'),
  ),
)
```

### 4️⃣ **Para Inputs Customizados**

```dart
// Inputs que usam o componente Input já têm tracking automático!
Input(
  'Meu Campo',
  controller: controller,
  // Tracking automático já aplicado
)

// Para inputs customizados:
TextField(
  onTap: () {
    final route = ModalRoute.of(context);
    final pageName = route?.settings.name ?? 'nome_da_pagina';
    AnalyticsService.trackEvent(
      elementId: 'meu_input_customizado',
      eventType: 'CLICK',
      page: pageName,
    );
  },
  // Outras propriedades
)
```

## 🎯 Métodos Disponíveis

### Método Principal (Mais Flexível)
```dart
AnalyticsService.trackEvent(
  elementId: 'nome_do_elemento',
  eventType: 'CLICK', // ou 'PAGE_VIEW' ou 'LOADING'
  page: 'nome_da_pagina',
  loading: 1234567890, // opcional, apenas para LOADING
);
```

### Métodos Específicos (Mais Simples)
```dart
// Para botões
AnalyticsService.trackButtonClick('texto_do_botao', 'nome_da_pagina');

// Para visualização de páginas
AnalyticsService.trackPageView('nome_da_pagina', tempoCarregamento);

// Para tempo de carregamento
AnalyticsService.trackPageLoading('nome_da_pagina', tempoCarregamento);

// Para cards
AnalyticsService.trackCardClick('nome_do_card', 'nome_da_pagina');

// Para inputs
AnalyticsService.trackInputFocus('label_do_input', 'nome_da_pagina');

// Para navegação
AnalyticsService.trackNavigation('pagina_origem', 'pagina_destino');
```

## 📝 Regras de Nomenclatura

### ElementId (Nome do Componente)
- **Formato**: snake_case (letras minúsculas com underscore)
- **Exemplos**:
  - ✅ `adicionar_despesa`
  - ✅ `salvar_configuracoes`
  - ✅ `card_grupo_viagem`
  - ❌ `AdicionarDespesa`
  - ❌ `button_salvar`

### Page (Nome da Página)
- **Formato**: snake_case terminando com `_screen`
- **Exemplos**:
  - ✅ `home_screen`
  - ✅ `configuracoes_screen`
  - ✅ `criar_transacao_screen`
  - ❌ `HomeScreen`
  - ❌ `home`

## 🔧 Exemplos Práticos Completos

### Exemplo 1: Tela de Perfil do Usuário
```dart
import 'package:divide_ai/services/analytics_service.dart';

class PerfilUsuarioScreen extends StatefulWidget {
  @override
  State<PerfilUsuarioScreen> createState() => _PerfilUsuarioScreenState();
}

class _PerfilUsuarioScreenState extends State<PerfilUsuarioScreen> {
  late final int _pageLoadStartTime;

  @override
  void initState() {
    super.initState();
    _pageLoadStartTime = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loadTime = DateTime.now().millisecondsSinceEpoch - _pageLoadStartTime;
      AnalyticsService.trackPageView('perfil_usuario_screen', loadTime);
      AnalyticsService.trackPageLoading('perfil_usuario_screen', loadTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil do Usuário')),
      body: Column(
        children: [
          // Usando componente Button (tracking automático)
          Button(
            text: 'Editar Perfil',
            onPressed: () => navegarParaEdicao(),
          ),
          
          // Card customizado com tracking
          InkWell(
            onTap: () {
              AnalyticsService.trackEvent(
                elementId: 'card_estatisticas',
                eventType: 'CLICK',
                page: 'perfil_usuario_screen',
              );
              mostrarEstatisticas();
            },
            child: Card(
              child: Text('Ver Estatísticas'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Exemplo 2: Componente de Lista Customizada
```dart
class ListaCustomizada extends StatelessWidget {
  final List<String> itens;
  final Function(String) onItemTap;

  const ListaCustomizada({
    required this.itens,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itens.length,
      itemBuilder: (context, index) {
        final item = itens[index];
        return ListTile(
          title: Text(item),
          onTap: () {
            // Rastrear clique no item da lista
            final route = ModalRoute.of(context);
            final pageName = route?.settings.name ?? 'unknown_page';
            AnalyticsService.trackEvent(
              elementId: 'item_lista_${item.toLowerCase().replaceAll(' ', '_')}',
              eventType: 'CLICK',
              page: pageName,
            );
            
            onItemTap(item);
          },
        );
      },
    );
  }
}
```

## ⚠️ Dicas Importantes

### ✅ Boas Práticas
- Use nomes descritivos para `elementId`
- Sempre importe o `AnalyticsService`
- Teste em ambiente de desenvolvimento primeiro
- Mantenha consistência na nomenclatura

### ❌ Evite
- Nomes genéricos como `botao1`, `card`, `input`
- Caracteres especiais no `elementId`
- Esquecer de importar o serviço
- Duplicar tracking em componentes que já têm automático

### 🔍 Como Verificar se Está Funcionando
1. Execute o app em modo debug
2. Interaja com os componentes
3. Verifique os logs no console
4. Confirme se as requisições estão sendo enviadas para a API

## 📞 Componentes que JÁ TÊM Tracking Automático

Estes componentes **NÃO precisam** de implementação manual:
- ✅ `Button` (todos os tamanhos)
- ✅ `Input` (todos os tipos)
- ✅ `GroupCard`
- ✅ Telas: `HomeGroupScreen`, `TransactionsGroupScreen`, `CreateTransactionScreen`

## 🚀 Próximos Passos

1. **Identifique** o tipo de componente que você quer rastrear
2. **Escolha** o método apropriado do `AnalyticsService`
3. **Implemente** seguindo os exemplos deste guia
4. **Teste** a funcionalidade
5. **Documente** novos padrões que você criar

## 🎨 Casos de Uso Avançados

### Rastreamento de Formulários Complexos
```dart
class FormularioCompleto extends StatefulWidget {
  @override
  State<FormularioCompleto> createState() => _FormularioCompletoState();
}

class _FormularioCompletoState extends State<FormularioCompleto> {
  final _formKey = GlobalKey<FormState>();

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      // Rastrear envio bem-sucedido
      AnalyticsService.trackEvent(
        elementId: 'formulario_enviado_sucesso',
        eventType: 'CLICK',
        page: 'formulario_screen',
      );

      // Processar formulário
    } else {
      // Rastrear erro de validação
      AnalyticsService.trackEvent(
        elementId: 'formulario_erro_validacao',
        eventType: 'CLICK',
        page: 'formulario_screen',
      );
    }
  }
}
```

### Rastreamento de Navegação Entre Telas
```dart
void navegarParaNovaTela(BuildContext context) {
  final route = ModalRoute.of(context);
  final paginaAtual = route?.settings.name ?? 'unknown_page';

  // Rastrear navegação
  AnalyticsService.trackNavigation(paginaAtual, 'nova_tela_screen');

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NovaTela()),
  );
}
```

### Rastreamento de Ações em Modais/Dialogs
```dart
void mostrarDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmar Ação'),
      actions: [
        TextButton(
          onPressed: () {
            AnalyticsService.trackEvent(
              elementId: 'dialog_cancelar',
              eventType: 'CLICK',
              page: 'dialog_confirmacao',
            );
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            AnalyticsService.trackEvent(
              elementId: 'dialog_confirmar',
              eventType: 'CLICK',
              page: 'dialog_confirmacao',
            );
            Navigator.pop(context);
            executarAcao();
          },
          child: Text('Confirmar'),
        ),
      ],
    ),
  );
}
```

---

💡 **Dúvidas?** Consulte o código dos componentes já implementados como referência!
