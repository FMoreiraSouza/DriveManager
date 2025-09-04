<p align="center">
  <img src="assets/images/drive_manager_logo.png" alt="Logo" width="400">
</p>

![Flutter](https://img.shields.io/badge/Flutter-3.32.4-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue?logo=dart)
---

## 📃 Descrição

O Drive Manager é uma aplicação Flutter desenvolvida em Dart para gerenciamento de frotas, permitindo o monitoramento e administração eficiente de veículos e motoristas. A aplicação segue a Clean Architecture, com uma estrutura modular dividida em camadas: presentation (interface do usuário e controladores), domain (modelos, casos de uso e interfaces de repositório) e data (implementações de repositórios e acesso a dados). Essa arquitetura promove separação de responsabilidades, testabilidade e escalabilidade. O aplicativo se integra com o Vehicle Tracker (consulte o [repositório](https://github.com/FMoreiraSouza/VehicleTracker)), que simula o movimento de veículos, fornecendo dados como coordenadas, velocidades e notificações de defeitos em tempo real. A integração com o Supabase garante autenticação segura, armazenamento de dados e sincronização em tempo real, enquanto a API do Google Maps é utilizada para visualização das localizações dos veículos em um mapa interativo.

---

## 💻 Tecnologias Utilizadas

- **Dart**: Linguagem de programação principal.
- **Flutter**: Framework para interface de usuário e lógica do aplicativo.
- **Gerenciador setState**: Gerenciamento de estado local utilizando `setState` nos widgets e controladores personalizados.
- **Supabase**: Backend para autenticação, banco de dados e sincronização em tempo real.
- **Google Maps**: API para monitoramento em tempo real da localização dos veículos.

---

## 🛎️ Funcionalidades

- **Cadastro de Frota**: Adicione e gerencie veículos, incluindo informações como placa, marca, modelo, quilometragem e IMEI do rastreador (gerado aleatoriamente no aplicativo, já que o rastreador real não está disponível).
- **Acompanhamento em Tempo Real**: Visualize a movimentação dos veículos em um painel ou mapa, com dados fornecidos pelo **Vehicle Tracker**.
- **Notificações**: Receba alertas de defeitos em tempo real e solicite suporte para veículos com falhas.
- **Autenticação**: Login seguro para gestores, com armazenamento do nome de usuário.
- **Gerenciamento** de Estados de Tela: 
  - **Loading**: Indicadores de carregamento com `LoadPanel` e `CircularProgressIndicator` para operações assíncronas, como login, cadastro de veículos e busca de dados.
  - **Success**: Exibição de dados carregados, como listas de veículos, marcadores no mapa e notificações, com atualizações em tempo real via Supabase.
  - **Error**: Tratamento de erros com `SnackBar` para falhas gerais e `AlertDialog` para erros específicos, além de mensagens visuais para falhas de conexão no mapa.
  - **Toast Messages**: Notificações visuais via `SnackBar` para ações como cadastro bem-sucedido, erros ou alertas em tempo real, com opções interativas.

---

## ▶️ Como Rodar o Projeto

### Pré-requisitos

- **Flutter** 3.0 ou superior (com Dart incluído).
- **Visual Studio Code** (recomendado) com as extensões Flutter e Dart instaladas.
- Conta no [Supabase](https://supabase.com/) configurada.
- Chave da API do **Google Maps** para Android/iOS.

### Clone o repositório

- git clone <URL_DO_PROJETO>

### Configuração do Supabase

- Crie um projeto no Supabase:
- Acesse o Supabase Dashboard e crie um novo projeto.
- Copie a SUPABASE_URL e a SUPABASE_KEY fornecidas.
- Configure as credenciais:
  - Abra o arquivo lib/core/constants/database_keys.dart.
  - Insira as credenciais SUPABASE_URL e SUPABASE_KEY do Supabase no arquivo.
- Crie as tabelas no Supabase:
  - No painel do Supabase, acesse a seção SQL Editor e execute os seguintes scripts para criar as tabelas necessárias:
    ```bash
    sqlCREATE TABLE public.vehicles (
    id SERIAL NOT NULL,
    plate_number TEXT NULL,
    brand TEXT NULL,
    model TEXT NULL,
    mileage REAL NULL,
    imei BIGINT NULL,
    hasDefect BOOLEAN NULL DEFAULT false,
    CONSTRAINT vehicles_pkey PRIMARY KEY (id)
    ) TABLESPACE pg_default;

    CREATE TABLE public.vehicle_coordinates (
      id SERIAL NOT NULL,
      latitude DOUBLE PRECISION NOT NULL,
      longitude DOUBLE PRECISION NOT NULL,
      timestamp TIMESTAMP WITH TIME ZONE NULL DEFAULT now(),
      imei BIGINT NULL,
      isStopped BOOLEAN NULL DEFAULT true,
      speed DOUBLE PRECISION NULL,
      CONSTRAINT vehicle_coordinates_pkey PRIMARY KEY (id)
    ) TABLESPACE pg_default;
    
    CREATE TABLE public.notifications (
      id SERIAL NOT NULL,
      message TEXT NOT NULL,
      created_at TIMESTAMP WITHOUT TIME ZONE NULL DEFAULT now(),
      plate_number TEXT NULL,
      CONSTRAINT notifications_pkey PRIMARY KEY (id)
    ) TABLESPACE pg_default;
- Habilite o Row Level Security (RLS):
  - No Supabase Dashboard, vá para Database > Tables e selecione cada tabela (vehicles, vehicle_coordinates, notifications).
  - Ative o RLS para cada tabela clicando em Enable RLS.
- Execute o seguinte script SQL no SQL Editor para configurar as políticas de RLS, permitindo leitura, inserção e atualização para usuários autenticados:
  ```bash
  -- Política para a tabela vehicles
  CREATE POLICY "Allow all operations for public on vehicles" ON public.vehicles
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);

  -- Política para a tabela vehicle_coordinates
  CREATE POLICY "Allow all operations for public on vehicle_coordinates" ON public.vehicle_coordinates
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);

  -- Política para a tabela notifications
  CREATE POLICY "Allow all operations for public on notifications" ON public.notifications
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);
- Habilite o Realtime:
  - Para ativar o Realtime nas tabelas vehicles, vehicle_coordinates e notifications, é necessário adicionar essas tabelas à publicação supabase_realtime (ou criar uma nova publicação, se preferir).
  - Execute o seguinte script SQL no SQL Editor do Supabase:
  ```bash
  sql-- Criar a publicação supabase_realtime (se ainda não existir)
  CREATE PUBLICATION supabase_realtime FOR TABLE public.vehicles, public.vehicle_coordinates, public.notifications;
  
  -- Caso a publicação já exista, adicione as tabelas à publicação existente
  ALTER PUBLICATION supabase_realtime ADD TABLE public.vehicles;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.vehicle_coordinates;
  ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

### Configuração do Google Maps

#### Obtenha uma chave de API:

  - Acesse o Google Cloud Console e crie um projeto.
  - Habilite a Maps SDK for Android e/ou Maps SDK for iOS.
  - Gere uma chave de API e restrinja-a para uso com o Drive Manager.

#### Configure a chave de API:

- Para Android, adicione a chave no arquivo android/app/src/main/AndroidManifest.xml: <meta-data android:name="com.google.android.geo.API_KEY" android:value="SUA_CHAVE_API_AQUI"/>

### Passos para rodar no Visual Studio Code

#### Instale as dependências:

- Abra o Visual Studio Code e carregue a pasta drive-manager-app.
- Abra o terminal integrado (Ctrl + ~) e execute: flutter pub get

#### Configure o ambiente Flutter:

- Certifique-se de que o Flutter está instalado e configurado corretamente: flutter doctor
- Resolva quaisquer problemas indicados pelo comando acima.

#### Configure o emulador ou dispositivo:

- Emulador:
  - No VS Code, clique em Run > Start Debugging ou pressione F5.
  - Selecione um emulador Android/iOS (recomendado: Pixel 6 com API 33 para Android).

- Dispositivo físico:
  - Conecte um dispositivo via USB com Modo Desenvolvedor e Depuração USB habilitados ou use Depuração sem fio (em Opções do desenvolvedor no dispositivo) e conecte via Wi-Fi.

#### Execute o aplicativo:

- No VS Code, clique em Run > Run Without Debugging ou pressione Ctrl + F5 ou alternativamente, no terminal, execute: flutter run.
- O aplicativo será compilado e executado no emulador ou dispositivo.

## 🎥 Apresentação do Aplicativo

Confira a apresentação do aplicativo: [Apresentação](https://youtu.be/xgrYM1RJArE)
