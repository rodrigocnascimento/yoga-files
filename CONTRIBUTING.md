# 🤝 Contribuindo para o Yoga Files

> **Como transformar sua paixão por desenvolvimento em contribuições valiosas**

## 🧘 **Filosofia YOGA**

Contribuições ao yoga-files seguem a filosofia:

- 🧘 **Clareza e Simplicidade**: Soluções elegantes e diretas
- 🔥 **Energia e Performance**: Otimização constante e velocidade
- 💧 **Adaptabilidade (Água)**: Flexibilidade e fluidez nas mudanças
- 🌿 **Estabilidade (Terra)**: Fundações sólidas e backward compatibility
- 🌬️ **Inovação (Ar)**: Novas ideias e abordagens criativas
- 🧘 **Espírito (Consciência)**: Aprendizado constante e melhoria contínua

---

## 🚀 **Como Contribuir**

### 📋 **1. Prepare seu Ambiente**

```bash
# 1. Fork o repositório
git clone https://github.com/rodrigocnascimento/yoga-files.git
cd yoga-files

# 2. Crie uma branch para sua feature
git checkout -b feature/sua-contribuicao

# 3. Configure seu ambiente de desenvolvimento
git config user.name "Seu Nome"
git config user.email "seu.email@exemplo.com"

# 4. Teste suas mudanças
git status
```

### 🎨 **2. Desenvolva sua Feature**

#### **Diretrizes de Código**
- **TypeScript first**: Use TypeScript em novos arquivos quando fizer sentido
- **Padrão YOGA**: Mantenha consistência com funções yoga_*
- **Performance**: Evite loops desnecessários e operações lentas
- **Documentação**: Documente suas mudanças com exemplos

#### **Estrutura de Arquivos**
```
yoga-files/
├── core/
│   ├── sua-feature/
│   │   ├── install.sh
│   │   ├── config.sh
│   │   └── functions.sh
│   └── tests/
│       └── test-sua-feature.sh
├── docs/
│   └── sua-feature-guide.md
└── tests/
    └── sua-feature-integration.sh
```

#### **Exemplo de Função Yoga**
```bash
# Sua função com tema yoga
yoga_sua_feature() {
    # Use sempre as cores yoga
    yoga_fogo "🔥 Executando sua feature..."
    yoga_agua "💧 Processando dados..."
    
    # Sua lógica aqui
    if [[ $condition ]]; then
        yoga_terra "🌿 Feature aplicada com sucesso!"
    else
        yoga_fogo "❌ Condição não atendida"
    fi
}
```

### 📝 **3. Teste ABRANGENTE**

```bash
# Smoke tests (zsh)
zsh ./tests/smoke.zsh
```

### 📋 **4. Documente sua Contribuição**

Crie documentação clara em `docs/sua-feature-guide.md`:
- **Objetivo**: O que a feature faz
- **Instalação**: Como configurar
- **Uso**: Exemplos práticos
- **API**: Funções exportadas (se aplicável)
- **Troubleshooting**: Problemas comuns e soluções

---

## 🎯 **5. Envie sua Contribuição**

### Pull Request Perfeito

Use nosso template de PR:

```markdown
## 🧘 YOGA FEATURE: [Sua Feature]

### ✅ **Descrição**
Breve descrição do que sua feature faz.

### 🔥 **Mudanças**
- **Adicionado**: `core/sua-feature/` - Módulo completo
- **Modificado**: `install.sh` - Integração com instalador principal
- **Novo**: `docs/sua-feature-guide.md` - Documentação

### 🌿 **Testes**
- [x] Testes unitários passando
- [x] Testes de integração funcionando
- [x] Documentação atualizada
- [x] Backward compatibility mantida

### 💧 **Como Usar**
1. Sincronize latest do main: `git pull origin main`
2. Merge sua branch: `git checkout main && git merge feature/sua-contribuicao`
3. Push: `git push origin main`

### 📋 **Checklist**
- [ ] Código segue os padrões YOGA
- [ ] Documentação completa e clara
- [ ] Testes passando (90%+)
- [ ] Sem breaking changes sem documentação
- [ ] Performance otimizada
```

---

## 🏆 **Áreas de Contribuição Prioritárias**

### 🚀 **Altíssima Prioridade**
- **Correção de Bugs Críticos**: Problemas que quebram funcionalidades
- **Segurança**: Vulnerabilidades e proteção de dados
- **Performance**: Melhorias de velocidade significativas

### 🔥 **Alta Prioridade**
- **Novas Features**: Funcionalidades inovadoras
- **Integrações**: Conexão com novas ferramentas
- **Documentação**: Guias e tutoriais

### 💧 **Média Prioridade**
- **Melhorias**: Refatoração e otimizações
- **UI/UX**: Melhorias na experiência do usuário
- **Testes**: Expansão da cobertura de testes

### 🌿 **Baixa Prioridade**
- **Documentação**: Correção de erros e melhorias
- **Exemplos**: Adicionar casos de uso
- **Traduções**: Adaptar para múltiplos idiomas

---

## 🤝 **Tipos de Contribuição**

### 👨‍💻 **Desenvolvedor**
- Novas funcionalidades
- Correções de bugs
- Melhorias de performance
- Integrações com APIs externas

### 🎨 **Designer/UX**
- Melhorias visuais e de interface
- Novos temas YOGA
- Templates de projeto
- Animações e transições

### 📝 **Escritor**
- Documentação técnica
- Tutoriais e guias
- Traduções
- Revisão de código

### 🧪 **Testador**
- Testes automatizados
- Testes de performance
- Validação cross-platform

---

## ⭐ **Reconhecimento**

Contribuidores notáveis receberão:
- **🏆 Yoga Master**: Contribuições transformacionais
- **🥇 Flow State**: Melhorias de performance
- **🔥 Fire Starter**: Funcionalidades críticas
- **💧 Water Adapter**: Adaptações e flexibilização
- **🌿 Earth Foundation**: Correções e estabilidade

---

## 🔗 **Links Importantes**

- **Issues**: https://github.com/rodrigocnascimento/yoga-files/issues
- **Discord**: https://discord.gg/yoga-files
- **Wiki**: https://yoga-files.dev/docs
- **Roadmap**: https://github.com/rodrigocnascimento/yoga-files/projects/1

---

**Junte-se à comunidade yoga-files e ajude a transformar o desenvolvimento!**

**Sua contribuição faz toda a diferença! 🧘✨**
