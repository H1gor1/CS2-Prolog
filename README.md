# Sistema Especialista em CS2 em Prolog

![Logo do CS2](https://cdn.cloudflare.steamstatic.com/steam/apps/730/header.jpg)

Um sistema especialista em Prolog para análise de dados do cenário competitivo de CS2, com estatísticas de jogadores, times, campeonatos e mais.

## 📌 Funcionalidades

- **Análise de Jogadores**: Melhores jogadores, dream teams, estatísticas por função
- **Comparação de Times**: Médias de rating, simulações de confrontos, rankings
- **Dados de Campeonatos**: Dificuldade dos eventos, times participantes
- **Estatísticas por País**: Melhores jogadores por nacionalidade, força das equipes nacionais
- **Métricas de Funções**: Funções mais impactantes, jogadores acima da média

## ⚙️ Instalação

1. Instale o [SWI-Prolog](https://www.swi-prolog.org/)
2. Clone este repositório
3. Certifique-se que todos os arquivos estão no mesmo diretório:
   - `main.pl` (Menu principal)
   - `regras.pl` (Regras e lógica)
   - `utils.pl` (Utilitários)
   - `csgo_fatos.pl` (Banco de dados)

## 🚀 Como Usar

1. Abra o terminal no diretório do projeto
2. Inicie o Prolog:
```bash
     swipl main.pl
```
3. Execute o menu interativo:
```prolog
  ?- menu_loop.
```
4. Navegue usando o sistema de menus numerados.

## 🔍 Consultas Diretas

Execute estas consultas no Prolog para dados específicos:
```prolog
% Obter todos os jogadores de um time
?- jogadoresDeUmTime("Vitality", Jogadores).

% Encontrar o melhor AWPer do Brasil
?- melhor_jogador_funcao_pais("AWPer", "Brasil", MelhorJogador).

% Simular um confronto Vitality vs NAVI
?- combate("Vitality", "Natus Vincere", Vencedor).

% Obter os top 5 jogadores por rating
?- top_jogadores().
```

## 📂 Estrutura de Arquivos

|  Arquivo      |  Finalidade                 |
|---------------|-----------------------------|
| main.pl       | Sistema de menu interativo  |
| regras.pl     | Lógica principal e regras   |
| utils.pl      | Utilitários                 |
| csgo_fatos.pl | Banco de fatos              |







