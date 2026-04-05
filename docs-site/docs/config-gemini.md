---
id: config-gemini
title: Configuração do Gemini
sidebar_position: 3
---

# 🤖 Configurando o Gemini no Yoga-Files

Nesta sessão, detalhamos como o `config.yaml` foi ajustado para parar de usar a OpenAI e passar a utilizar o **Google Gemini 1.5 Pro** como motor de inteligência artificial primário.

## O que foi alterado no `config.yaml`

Para alterar o provedor de IA, modificamos as seguintes chaves no arquivo raiz de configurações:

### 1. Alteração do Provedor Padrão
Trocamos a chave de `openai` para `gemini`:
```yaml
preferences:
  theme: "yoga_elements"
  ai_provider: "gemini" # <--- Modificado aqui
```

### 2. Definição do Modelo
Setamos o modelo correto da família Gemini que possui uma ótima janela de contexto e compreensão de código:
```yaml
  ai:
    model: "gemini-1.5-pro" # <--- Alterado de gpt-4
    max_tokens: 2000
```

### 3. Bloco de Integração
Adicionamos o objeto `gemini` na seção de integrações para que os scripts shell leiam a variável de ambiente correta:
```yaml
integrations:
  gemini:
    enabled: true
    api_key: "${GEMINI_API_KEY}" # O sistema lerá essa ENV
    
  openai:
    enabled: false # Desativamos para não haver conflitos
```

## Como Testar
Com essas alterações feitas, qualquer chamada no terminal via `yoga-ai` será redirecionada automaticamente para a API do Google:

```bash
export GEMINI_API_KEY="sua_chave_aqui"
yoga-ai "Explique o que é a Clean Architecture"
```