Teste Mobile Onfly - Descrição Detalhada

O projeto foi desenvolvido utilizando o framework Flutter. Na tela inicial do aplicativo, os usuários encontrarão uma lista completa de todas as suas despesas, incluindo informações como descrição, data/hora e preço da despesa. Ao selecionar um dos cards da lista, os usuários serão redirecionados para a tela de edição, onde poderão visualizar e modificar os detalhes da despesa, além de terem a opção de salvar as alterações ou excluir a despesa. A tela inicial também oferece as opções de logout, permitindo que os usuários façam logout do aplicativo, e de cadastrar uma nova despesa, o que os levará a uma tela para inserir os dados da nova despesa.

Quando uma despesa é salva, todos os campos são validados e, se estiverem corretos, juntamente com a latitude e longitude do dispositivo, são enviados em uma requisição para o servidor. Mesmo se o usuário estiver offline, ainda poderá salvar e editar despesas normalmente. Assim que a conexão for restabelecida, todas as despesas cadastradas offline serão automaticamente enviadas para o servidor.

Algumas observações importantes:

1) Para sincronizar as despesas cadastradas offline, é necessário fazer logout e login no aplicativo ou abrir a tela de cadastro de despesa para acionar a requisição. Devido a limitações de tempo, não foi implementado um ouvinte em tempo real para verificar a disponibilidade de conexão.

2) O cadastro de hora na despesa não foi implementado.

===== Instruções de instalação: =====

Para instalar o aplicativo, você pode executá-lo das seguintes maneiras:

Linha de comando:

flutter run --no-sound-null-safety

No VS Code, inclua os argumentos no arquivo launch.json:

"args": [
  "--no-sound-null-safety"
]

No Android Studio, inclua o argumento em Run/Debug Configuration:

--no-sound-null-safety

===== Resumo das práticas utilizadas no projeto: =====

Padrão Arquitetural:
Adotei o padrão MVVM no projeto, que é um padrão arquitetural amplamente reconhecido no desenvolvimento de aplicativos Flutter, garantindo organização, escalabilidade e facilidade na manutenção.

Reutilização de Código:
Para o melhor reaproveitamento de código, foram utilizados widgets, classes, funções e bibliotecas reutilizáveis, garantindo a qualidade do desenvolvimento, escalabilidade e facilitando a manutenção futura.

Gerenciamento de Estado:
Para gerenciar o estado do aplicativo, foram utilizadas as bibliotecas MobX e GetIt, simplificando a conexão e o gerenciamento de dados reativos nas interfaces do aplicativo.

Requisições HTTP:
As requisições HTTP foram tratadas com a biblioteca DIO, um pacote poderoso para comunicação de rede HTTP em Dart/Flutter, oferecendo suporte a configurações globais, interceptores, entre outros.

Geolocalização:
Para acessar os serviços de localização do dispositivo, foi adotada a biblioteca Geolocator, que facilita o acesso à localização em diferentes sistemas operacionais.

Persistência de Dados:
Para a persistência de dados local, foi utilizada a biblioteca sqflite, um plugin que integra um mecanismo de banco de dados SQL independente e altamente confiável.

Outras Bibliotecas:
Também foram utilizadas outras bibliotecas, como a image_cropper (que oferece suporte ao recorte de imagens), para melhorar a experiência e otimização do aplicativo.

P.S:
Basicamente é isso pessoal. Espero que gostem rsrs :) Qualquer dúvida podem me chamar!
