import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt')
  ];

  /// No description provided for @aboard.
  ///
  /// In pt, this message translates to:
  /// **'a bordo'**
  String get aboard;

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @aboutLine1.
  ///
  /// In pt, this message translates to:
  /// **'Este projeto é de código aberto e pode ser encontrado em'**
  String get aboutLine1;

  /// No description provided for @aboutLine2.
  ///
  /// In pt, this message translates to:
  /// **'Se você gostou do meu trabalho\ndemonstre algum ♥ e ⭐ no repositório'**
  String get aboutLine2;

  /// No description provided for @accent.
  ///
  /// In pt, this message translates to:
  /// **'Cor de Destaque & Matiz'**
  String get accent;

  /// No description provided for @addNew.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Novo'**
  String get addNew;

  /// No description provided for @addSomething.
  ///
  /// In pt, this message translates to:
  /// **'Escolha e Adicione Algo'**
  String get addSomething;

  /// No description provided for @addToPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à Playlist'**
  String get addToPlaylist;

  /// No description provided for @addToQueue.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à Fila'**
  String get addToQueue;

  /// No description provided for @addedBy.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado por'**
  String get addedBy;

  /// No description provided for @addedTo.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado a'**
  String get addedTo;

  /// No description provided for @addedToFav.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado em Favoritos'**
  String get addedToFav;

  /// No description provided for @addedToPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado às Playlists'**
  String get addedToPlaylists;

  /// No description provided for @addedToQueue.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado à Fila'**
  String get addedToQueue;

  /// No description provided for @adjustSpeed.
  ///
  /// In pt, this message translates to:
  /// **'Ajustar Velocidade'**
  String get adjustSpeed;

  /// No description provided for @album.
  ///
  /// In pt, this message translates to:
  /// **'Álbum'**
  String get album;

  /// No description provided for @albumArtist.
  ///
  /// In pt, this message translates to:
  /// **'Artista do Álbum'**
  String get albumArtist;

  /// No description provided for @albums.
  ///
  /// In pt, this message translates to:
  /// **'Álbuns'**
  String get albums;

  /// No description provided for @alphabetical.
  ///
  /// In pt, this message translates to:
  /// **'Ordem Alfabética'**
  String get alphabetical;

  /// No description provided for @alreadyExists.
  ///
  /// In pt, this message translates to:
  /// **'Já Existe'**
  String get alreadyExists;

  /// No description provided for @alreadyInQueue.
  ///
  /// In pt, this message translates to:
  /// **'Já está na fila'**
  String get alreadyInQueue;

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'XMusic'**
  String get appTitle;

  /// No description provided for @artist.
  ///
  /// In pt, this message translates to:
  /// **'Artista'**
  String get artist;

  /// No description provided for @artists.
  ///
  /// In pt, this message translates to:
  /// **'Artistas'**
  String get artists;

  /// No description provided for @autoBack.
  ///
  /// In pt, this message translates to:
  /// **'Backup Automático'**
  String get autoBack;

  /// No description provided for @autoBackSub.
  ///
  /// In pt, this message translates to:
  /// **'Backup automático dos seus dados'**
  String get autoBackSub;

  /// No description provided for @autoplay.
  ///
  /// In pt, this message translates to:
  /// **'Reprodução Automática'**
  String get autoplay;

  /// No description provided for @autoplaySub.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar músicas relacionadas à fila automaticamente'**
  String get autoplaySub;

  /// No description provided for @back.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get back;

  /// No description provided for @backNRest.
  ///
  /// In pt, this message translates to:
  /// **'Backup e Restauração'**
  String get backNRest;

  /// No description provided for @backupSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup Concluído'**
  String get backupSuccess;

  /// No description provided for @bgGrad.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente do Plano Fundo'**
  String get bgGrad;

  /// No description provided for @bgGradSub.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente usado como plano de fundo em todos os lugares'**
  String get bgGradSub;

  /// No description provided for @blacklistedHomeSections.
  ///
  /// In pt, this message translates to:
  /// **'Seções da Tela Inicial na Blacklist'**
  String get blacklistedHomeSections;

  /// No description provided for @blacklistedHomeSectionsSub.
  ///
  /// In pt, this message translates to:
  /// **'As seções com esses títulos não serão mostradas na tela inicial'**
  String get blacklistedHomeSectionsSub;

  /// No description provided for @bottomGrad.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente do Painel'**
  String get bottomGrad;

  /// No description provided for @bottomGradSub.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente usado nos Paineis'**
  String get bottomGradSub;

  /// No description provided for @buyCoffee.
  ///
  /// In pt, this message translates to:
  /// **'Me compre um café'**
  String get buyCoffee;

  /// No description provided for @cache.
  ///
  /// In pt, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No description provided for @cacheSong.
  ///
  /// In pt, this message translates to:
  /// **'Músicas em Cache'**
  String get cacheSong;

  /// No description provided for @cacheSongSub.
  ///
  /// In pt, this message translates to:
  /// **'As músicas serão armazenadas em cache para reprodução futura. Espaço adicional no seu dispositivo será ocupado'**
  String get cacheSongSub;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @cantAddToQueue.
  ///
  /// In pt, this message translates to:
  /// **'Não pode adicionar Músicas Online para a fila Offline'**
  String get cantAddToQueue;

  /// No description provided for @canvasColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor de Tela'**
  String get canvasColor;

  /// No description provided for @canvasColorSub.
  ///
  /// In pt, this message translates to:
  /// **'Cor da Tela de Fundo'**
  String get canvasColorSub;

  /// No description provided for @cardColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor do Card'**
  String get cardColor;

  /// No description provided for @cardColorSub.
  ///
  /// In pt, this message translates to:
  /// **'Cor da Barra de Pesquisa, Diálogos de Alerta, Cards'**
  String get cardColorSub;

  /// No description provided for @cardGrad.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente do Card'**
  String get cardGrad;

  /// No description provided for @cardGradSub.
  ///
  /// In pt, this message translates to:
  /// **'Gradiente usado nos Cards'**
  String get cardGradSub;

  /// No description provided for @changeDefault.
  ///
  /// In pt, this message translates to:
  /// **'Predefinir'**
  String get changeDefault;

  /// No description provided for @changeOrder.
  ///
  /// In pt, this message translates to:
  /// **'Pressione e segure para alterar a ordem\n'**
  String get changeOrder;

  /// No description provided for @chartLocation.
  ///
  /// In pt, this message translates to:
  /// **'Localização das Paradas Locais do Spotify'**
  String get chartLocation;

  /// No description provided for @chartLocationSub.
  ///
  /// In pt, this message translates to:
  /// **'País que deseja ver as Paradas Locais do Spotify'**
  String get chartLocationSub;

  /// No description provided for @checkingUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Procurando por atualizações…'**
  String get checkingUpdate;

  /// No description provided for @checkUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Atualizações Automáticas'**
  String get checkUpdate;

  /// No description provided for @checkUpdateSub.
  ///
  /// In pt, this message translates to:
  /// **'Mantenha essa opção ativa para atualizações automáticas'**
  String get checkUpdateSub;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @clearAll.
  ///
  /// In pt, this message translates to:
  /// **'Limpar Tudo'**
  String get clearAll;

  /// No description provided for @clearCache.
  ///
  /// In pt, this message translates to:
  /// **'Informações Salvas'**
  String get clearCache;

  /// No description provided for @clearCacheSub.
  ///
  /// In pt, this message translates to:
  /// **'Exclui informações salvas incluindo Página inicial, Spotify Top Charts, YouTube e informações da última sessão. Normalmente o app limpa automaticamente essas informações quando se tornam muito grandes\n'**
  String get clearCacheSub;

  /// No description provided for @connectingRadio.
  ///
  /// In pt, this message translates to:
  /// **'Conectando com o Rádio…'**
  String get connectingRadio;

  /// No description provided for @contactUs.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get contactUs;

  /// No description provided for @contactUsSub.
  ///
  /// In pt, this message translates to:
  /// **'Comentários e sugestões são bem vindos'**
  String get contactUsSub;

  /// No description provided for @convertingSongs.
  ///
  /// In pt, this message translates to:
  /// **'Convertendo as Músicas'**
  String get convertingSongs;

  /// No description provided for @copied.
  ///
  /// In pt, this message translates to:
  /// **'Copiado para a área de transferência!'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get copy;

  /// No description provided for @countryQue.
  ///
  /// In pt, this message translates to:
  /// **'Para qual país você gostaria de ver as Paradas Locais do Spotify?'**
  String get countryQue;

  /// No description provided for @createAlbumFold.
  ///
  /// In pt, this message translates to:
  /// **'Pasta para Álbum & Playlists Baixadas'**
  String get createAlbumFold;

  /// No description provided for @createAlbumFoldSub.
  ///
  /// In pt, this message translates to:
  /// **'Cria pastas comuns para as Músicas quando Álbum ou Playlist forem baixadas'**
  String get createAlbumFoldSub;

  /// No description provided for @createBack.
  ///
  /// In pt, this message translates to:
  /// **'Backup'**
  String get createBack;

  /// No description provided for @createBackSub.
  ///
  /// In pt, this message translates to:
  /// **'Faça backup dos seus dados'**
  String get createBackSub;

  /// No description provided for @createNewPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Criar uma Nova Playlist'**
  String get createNewPlaylist;

  /// No description provided for @createPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Criar Playlist'**
  String get createPlaylist;

  /// No description provided for @createYtFold.
  ///
  /// In pt, this message translates to:
  /// **'Pastas Diferentes para YouTube'**
  String get createYtFold;

  /// No description provided for @createYtFoldSub.
  ///
  /// In pt, this message translates to:
  /// **'Cria uma pasta diferente para as Músicas baixadas pelo YouTube'**
  String get createYtFoldSub;

  /// No description provided for @currentTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema Atual'**
  String get currentTheme;

  /// No description provided for @darkMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get darkMode;

  /// No description provided for @date.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @dateAdded.
  ///
  /// In pt, this message translates to:
  /// **'Data Adicionada'**
  String get dateAdded;

  /// No description provided for @dec.
  ///
  /// In pt, this message translates to:
  /// **'Decrescente'**
  String get dec;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Apagar'**
  String get delete;

  /// No description provided for @deleted.
  ///
  /// In pt, this message translates to:
  /// **'Apagado'**
  String get deleted;

  /// No description provided for @deleteTheme.
  ///
  /// In pt, this message translates to:
  /// **'Apagar Tema'**
  String get deleteTheme;

  /// No description provided for @deleteThemeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Você tem certeza que quer apagar?'**
  String get deleteThemeSubtitle;

  /// No description provided for @disclaimer.
  ///
  /// In pt, this message translates to:
  /// **'Isenção de Responsabilidade:'**
  String get disclaimer;

  /// No description provided for @disclaimerText.
  ///
  /// In pt, this message translates to:
  /// **'Nós respeitamos sua privacidade mais que qualquer outra coisa. Todos os seus dados são armazenados localmente apenas no seu dispositivo.'**
  String get disclaimerText;

  /// No description provided for @displayName.
  ///
  /// In pt, this message translates to:
  /// **'Nome em Exibição'**
  String get displayName;

  /// No description provided for @donateGpay.
  ///
  /// In pt, this message translates to:
  /// **'Doar com GPay'**
  String get donateGpay;

  /// No description provided for @donateGpaySub.
  ///
  /// In pt, this message translates to:
  /// **'Qualquer quantia me faz sorrir :)\nToque para doar ou clique e segure para copiar o ID da UPI'**
  String get donateGpaySub;

  /// No description provided for @down.
  ///
  /// In pt, this message translates to:
  /// **'Download'**
  String get down;

  /// No description provided for @downAgain.
  ///
  /// In pt, this message translates to:
  /// **'já existe.\nVocê quer baixar novamente?'**
  String get downAgain;

  /// No description provided for @downDone.
  ///
  /// In pt, this message translates to:
  /// **'Download Concluído'**
  String get downDone;

  /// No description provided for @downLocation.
  ///
  /// In pt, this message translates to:
  /// **'Local de Download'**
  String get downLocation;

  /// No description provided for @downLyrics.
  ///
  /// In pt, this message translates to:
  /// **'Letras'**
  String get downLyrics;

  /// No description provided for @downLyricsSub.
  ///
  /// In pt, this message translates to:
  /// **'Baixar as letras junto com a música, se possível'**
  String get downLyricsSub;

  /// No description provided for @downQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade do Download'**
  String get downQuality;

  /// No description provided for @downQualitySub.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade alta usa mais espaço na memória'**
  String get downQualitySub;

  /// No description provided for @downed.
  ///
  /// In pt, this message translates to:
  /// **'foi baixada'**
  String get downed;

  /// No description provided for @downingAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Baixando o Álbum'**
  String get downingAlbum;

  /// No description provided for @downloadSomething.
  ///
  /// In pt, this message translates to:
  /// **'Baixe Algo'**
  String get downloadSomething;

  /// No description provided for @downs.
  ///
  /// In pt, this message translates to:
  /// **'Downloads'**
  String get downs;

  /// No description provided for @duration.
  ///
  /// In pt, this message translates to:
  /// **'Duração'**
  String get duration;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @enableGesture.
  ///
  /// In pt, this message translates to:
  /// **'Gestos no Player'**
  String get enableGesture;

  /// No description provided for @enableGestureSub.
  ///
  /// In pt, this message translates to:
  /// **'Toque, solte ou deslize na tela do player para ter algumas ações'**
  String get enableGestureSub;

  /// No description provided for @enforceRepeat.
  ///
  /// In pt, this message translates to:
  /// **'Forçar Repetição'**
  String get enforceRepeat;

  /// No description provided for @enforceRepeatSub.
  ///
  /// In pt, this message translates to:
  /// **'Manter a mesma opção de repetição para cada sessão'**
  String get enforceRepeatSub;

  /// No description provided for @enterName.
  ///
  /// In pt, this message translates to:
  /// **'Digite o seu nome'**
  String get enterName;

  /// No description provided for @enterPlaylistLink.
  ///
  /// In pt, this message translates to:
  /// **'Coloque o Link da Playlist'**
  String get enterPlaylistLink;

  /// No description provided for @enterSongsCount.
  ///
  /// In pt, this message translates to:
  /// **'Digite o Número de Músicas'**
  String get enterSongsCount;

  /// No description provided for @enterText.
  ///
  /// In pt, this message translates to:
  /// **'Digite o Texto'**
  String get enterText;

  /// No description provided for @enterThemeName.
  ///
  /// In pt, this message translates to:
  /// **'Coloque o Nome do Tema'**
  String get enterThemeName;

  /// No description provided for @equalizer.
  ///
  /// In pt, this message translates to:
  /// **'Equalizador'**
  String get equalizer;

  /// No description provided for @exitConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Pressione novamente para sair do aplicativo'**
  String get exitConfirm;

  /// No description provided for @export.
  ///
  /// In pt, this message translates to:
  /// **'Exportar'**
  String get export;

  /// No description provided for @exported.
  ///
  /// In pt, this message translates to:
  /// **'Exportado'**
  String get exported;

  /// No description provided for @failedCreateBackup.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao criar o Backup'**
  String get failedCreateBackup;

  /// No description provided for @failedDelete.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao Apagar'**
  String get failedDelete;

  /// No description provided for @failedExport.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao Exportar'**
  String get failedExport;

  /// No description provided for @failedImport.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao Importar'**
  String get failedImport;

  /// No description provided for @failedTagEdit.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao tentar editar as tags'**
  String get failedTagEdit;

  /// No description provided for @favorites.
  ///
  /// In pt, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @fetchingStream.
  ///
  /// In pt, this message translates to:
  /// **'Buscando Música'**
  String get fetchingStream;

  /// No description provided for @finish.
  ///
  /// In pt, this message translates to:
  /// **'Concluído'**
  String get finish;

  /// No description provided for @from.
  ///
  /// In pt, this message translates to:
  /// **'de'**
  String get from;

  /// No description provided for @genre.
  ///
  /// In pt, this message translates to:
  /// **'Gênero'**
  String get genre;

  /// No description provided for @genres.
  ///
  /// In pt, this message translates to:
  /// **'Gêneros'**
  String get genres;

  /// No description provided for @getStarted.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get getStarted;

  /// No description provided for @global.
  ///
  /// In pt, this message translates to:
  /// **'Global'**
  String get global;

  /// No description provided for @gmail.
  ///
  /// In pt, this message translates to:
  /// **'Gmail'**
  String get gmail;

  /// No description provided for @guest.
  ///
  /// In pt, this message translates to:
  /// **'Humano'**
  String get guest;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get home;

  /// No description provided for @importFile.
  ///
  /// In pt, this message translates to:
  /// **'Importar de um Arquivo'**
  String get importFile;

  /// No description provided for @importPublicPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Importar uma Playlist Pública'**
  String get importPublicPlaylist;

  /// No description provided for @importSpotify.
  ///
  /// In pt, this message translates to:
  /// **'Importar do Spotify'**
  String get importSpotify;

  /// No description provided for @importSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Importado com sucesso'**
  String get importSuccess;

  /// No description provided for @importYt.
  ///
  /// In pt, this message translates to:
  /// **'Importar do YouTube'**
  String get importYt;

  /// No description provided for @inc.
  ///
  /// In pt, this message translates to:
  /// **'Crescente'**
  String get inc;

  /// No description provided for @insta.
  ///
  /// In pt, this message translates to:
  /// **'Instagram'**
  String get insta;

  /// No description provided for @ipAdd.
  ///
  /// In pt, this message translates to:
  /// **'Endereço de IP'**
  String get ipAdd;

  /// No description provided for @joinTg.
  ///
  /// In pt, this message translates to:
  /// **'Junte-se a nós no Telegram'**
  String get joinTg;

  /// No description provided for @joinTgSub.
  ///
  /// In pt, this message translates to:
  /// **'Quer testar as versões Beta? Junte-se a nós!'**
  String get joinTgSub;

  /// No description provided for @lang.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get lang;

  /// No description provided for @langQue.
  ///
  /// In pt, this message translates to:
  /// **'Em qual idioma das músicas você gostaria de ouvir?'**
  String get langQue;

  /// No description provided for @langSub.
  ///
  /// In pt, this message translates to:
  /// **'Idioma do App'**
  String get langSub;

  /// No description provided for @lastAdded.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado por Último'**
  String get lastAdded;

  /// No description provided for @lastModified.
  ///
  /// In pt, this message translates to:
  /// **'Última Modificação'**
  String get lastModified;

  /// No description provided for @lastSession.
  ///
  /// In pt, this message translates to:
  /// **'Última Sessão'**
  String get lastSession;

  /// No description provided for @latest.
  ///
  /// In pt, this message translates to:
  /// **'Parabéns! Você está usando a última versão :)'**
  String get latest;

  /// No description provided for @library.
  ///
  /// In pt, this message translates to:
  /// **'Biblioteca'**
  String get library;

  /// No description provided for @like.
  ///
  /// In pt, this message translates to:
  /// **'Curtir'**
  String get like;

  /// No description provided for @likedWork.
  ///
  /// In pt, this message translates to:
  /// **'Gostou do meu trabalho?'**
  String get likedWork;

  /// No description provided for @live.
  ///
  /// In pt, this message translates to:
  /// **'AO VIVO AGORA'**
  String get live;

  /// No description provided for @liveSearch.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisa em Tempo Real'**
  String get liveSearch;

  /// No description provided for @liveSearchSub.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise músicas assim que o usuário parar de digitar'**
  String get liveSearchSub;

  /// No description provided for @loadLast.
  ///
  /// In pt, this message translates to:
  /// **'Última Sessão ao Iniciar'**
  String get loadLast;

  /// No description provided for @loadLastSub.
  ///
  /// In pt, this message translates to:
  /// **'Automaticamente carregar última sessão quando o aplicativo iniciar'**
  String get loadLastSub;

  /// No description provided for @local.
  ///
  /// In pt, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @lyrics.
  ///
  /// In pt, this message translates to:
  /// **'Letras'**
  String get lyrics;

  /// No description provided for @madeBy.
  ///
  /// In pt, this message translates to:
  /// **'Feito com ♥ por Hendril Mendes'**
  String get madeBy;

  /// No description provided for @minAudioAlert.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo tamanho dos audios (em segundos)'**
  String get minAudioAlert;

  /// No description provided for @minAudioLen.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho mínimo das Músicas'**
  String get minAudioLen;

  /// No description provided for @minAudioLenSub.
  ///
  /// In pt, this message translates to:
  /// **'Audios com tamanho menor não serão mostradas na sessão de \'Minhas Músicas\''**
  String get minAudioLenSub;

  /// No description provided for @miniButtons.
  ///
  /// In pt, this message translates to:
  /// **'Botões para mostrar no Mini Player'**
  String get miniButtons;

  /// No description provided for @miniButtonsSub.
  ///
  /// In pt, this message translates to:
  /// **'Toque para alterar os botões mostrados no miniplayer'**
  String get miniButtonsSub;

  /// No description provided for @minutes.
  ///
  /// In pt, this message translates to:
  /// **'minutos'**
  String get minutes;

  /// No description provided for @sourceCode.
  ///
  /// In pt, this message translates to:
  /// **'Código Fonte'**
  String get sourceCode;

  /// No description provided for @sourceCodeSub.
  ///
  /// In pt, this message translates to:
  /// **'Código fonte do app'**
  String get sourceCodeSub;

  /// No description provided for @musicLang.
  ///
  /// In pt, this message translates to:
  /// **'Idioma das Músicas'**
  String get musicLang;

  /// No description provided for @musicLangSub.
  ///
  /// In pt, this message translates to:
  /// **'Idioma para exibição de músicas na tela inicial'**
  String get musicLangSub;

  /// No description provided for @musicPlayback.
  ///
  /// In pt, this message translates to:
  /// **'Músicas & Reprodução'**
  String get musicPlayback;

  /// No description provided for @myMusic.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Músicas'**
  String get myMusic;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @noFolderSelected.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma Pasta Selecionada'**
  String get noFolderSelected;

  /// No description provided for @noLangSelected.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum idioma de música selecionado. Selecione um idioma para ver músicas na Tela Inicial'**
  String get noLangSelected;

  /// No description provided for @notAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Não Disponível'**
  String get notAvailable;

  /// No description provided for @nothingIs.
  ///
  /// In pt, this message translates to:
  /// **'Nada está '**
  String get nothingIs;

  /// No description provided for @nothingPlaying.
  ///
  /// In pt, this message translates to:
  /// **'Nada está Tocando'**
  String get nothingPlaying;

  /// No description provided for @nothingTo.
  ///
  /// In pt, this message translates to:
  /// **'Nada para '**
  String get nothingTo;

  /// No description provided for @nowPlaying.
  ///
  /// In pt, this message translates to:
  /// **'Tocando Agora'**
  String get nowPlaying;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @or.
  ///
  /// In pt, this message translates to:
  /// **'OU'**
  String get or;

  /// No description provided for @others.
  ///
  /// In pt, this message translates to:
  /// **'Outros'**
  String get others;

  /// No description provided for @pause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In pt, this message translates to:
  /// **'Tocar'**
  String get play;

  /// No description provided for @playNext.
  ///
  /// In pt, this message translates to:
  /// **'Tocar Próxima'**
  String get playNext;

  /// No description provided for @playSomething.
  ///
  /// In pt, this message translates to:
  /// **'Vá e Toque Algo'**
  String get playSomething;

  /// No description provided for @playing.
  ///
  /// In pt, this message translates to:
  /// **'Tocando'**
  String get playing;

  /// No description provided for @playingCap.
  ///
  /// In pt, this message translates to:
  /// **'TOCANDO'**
  String get playingCap;

  /// No description provided for @playlistShareText.
  ///
  /// In pt, this message translates to:
  /// **'Olhe minha Playlist!'**
  String get playlistShareText;

  /// No description provided for @playlists.
  ///
  /// In pt, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @popularity.
  ///
  /// In pt, this message translates to:
  /// **'Popularidade'**
  String get popularity;

  /// No description provided for @port.
  ///
  /// In pt, this message translates to:
  /// **'Porta'**
  String get port;

  /// No description provided for @prefReq.
  ///
  /// In pt, this message translates to:
  /// **'Poderia informar algumas coisas?'**
  String get prefReq;

  /// No description provided for @proxySet.
  ///
  /// In pt, this message translates to:
  /// **'Configurações de Proxy'**
  String get proxySet;

  /// No description provided for @proxySetSub.
  ///
  /// In pt, this message translates to:
  /// **'Alterar IP e porta do proxy'**
  String get proxySetSub;

  /// No description provided for @rememberChoice.
  ///
  /// In pt, this message translates to:
  /// **'Lembrar minhas escolhas'**
  String get rememberChoice;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @removed.
  ///
  /// In pt, this message translates to:
  /// **'Removido'**
  String get removed;

  /// No description provided for @removedFrom.
  ///
  /// In pt, this message translates to:
  /// **'Removido do'**
  String get removedFrom;

  /// No description provided for @removedFromFav.
  ///
  /// In pt, this message translates to:
  /// **'Removido dos Favoritos'**
  String get removedFromFav;

  /// No description provided for @rename.
  ///
  /// In pt, this message translates to:
  /// **'Trocar o Nome'**
  String get rename;

  /// No description provided for @reset.
  ///
  /// In pt, this message translates to:
  /// **'Redefinir'**
  String get reset;

  /// No description provided for @restore.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar'**
  String get restore;

  /// No description provided for @restoreSub.
  ///
  /// In pt, this message translates to:
  /// **'Restaure suas informações usando um Backup'**
  String get restoreSub;

  /// No description provided for @resultsNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Resultados Não Encontrados'**
  String get resultsNotFound;

  /// No description provided for @savePlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Playlist'**
  String get savePlaylist;

  /// No description provided for @saveTheme.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Tema'**
  String get saveTheme;

  /// No description provided for @search.
  ///
  /// In pt, this message translates to:
  /// **'Procurar'**
  String get search;

  /// No description provided for @searchHome.
  ///
  /// In pt, this message translates to:
  /// **'Página Inicial de Pesquisa'**
  String get searchHome;

  /// No description provided for @searchText.
  ///
  /// In pt, this message translates to:
  /// **'Músicas, Álbuns ou Artistas'**
  String get searchText;

  /// No description provided for @searchVideo.
  ///
  /// In pt, this message translates to:
  /// **'Procurar Vídeo'**
  String get searchVideo;

  /// No description provided for @searchYt.
  ///
  /// In pt, this message translates to:
  /// **'Procurar no YouTube'**
  String get searchYt;

  /// No description provided for @selectBackFile.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o arquivo de Backup (.zip)'**
  String get selectBackFile;

  /// No description provided for @selectBackLocation.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar local de backup'**
  String get selectBackLocation;

  /// No description provided for @selectDownLocation.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o local de Download'**
  String get selectDownLocation;

  /// No description provided for @selectDur.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a Duração'**
  String get selectDur;

  /// No description provided for @selectExportLocation.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o local de Exportação'**
  String get selectExportLocation;

  /// No description provided for @selectJsonImport.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um arquivo JSON para importar'**
  String get selectJsonImport;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @share.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get share;

  /// No description provided for @shareApp.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar o App'**
  String get shareApp;

  /// No description provided for @shareAppSub.
  ///
  /// In pt, this message translates to:
  /// **'Fale sobre nós para seus amigos'**
  String get shareAppSub;

  /// No description provided for @shareAppText.
  ///
  /// In pt, this message translates to:
  /// **'Ei! Confira esse incrível app de música totalmente grátis'**
  String get shareAppText;

  /// No description provided for @showHere.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar Aqui'**
  String get showHere;

  /// No description provided for @showHistory.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar Histórico'**
  String get showHistory;

  /// No description provided for @showHistorySub.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar histórico abaixo da barra de pesquisa'**
  String get showHistorySub;

  /// No description provided for @showLast.
  ///
  /// In pt, this message translates to:
  /// **'Última Sessão'**
  String get showLast;

  /// No description provided for @showLastSub.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar última sessão na Tela Inicial'**
  String get showLastSub;

  /// No description provided for @showQr.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar QR Code'**
  String get showQr;

  /// No description provided for @shuffle.
  ///
  /// In pt, this message translates to:
  /// **'Misturar'**
  String get shuffle;

  /// No description provided for @size.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho'**
  String get size;

  /// No description provided for @skip.
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get skip;

  /// No description provided for @skipNext.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get skipNext;

  /// No description provided for @skipPrevious.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get skipPrevious;

  /// No description provided for @sleepAfter.
  ///
  /// In pt, this message translates to:
  /// **'Dormir depois de N Músicas'**
  String get sleepAfter;

  /// No description provided for @sleepAfterSub.
  ///
  /// In pt, this message translates to:
  /// **'Música irá parar depois de tocar as músicas selecionadas'**
  String get sleepAfterSub;

  /// No description provided for @sleepDur.
  ///
  /// In pt, this message translates to:
  /// **'Dormir depois de hh:mm'**
  String get sleepDur;

  /// No description provided for @sleepDurSub.
  ///
  /// In pt, this message translates to:
  /// **'Música irá parar depois do tempo selecionado'**
  String get sleepDurSub;

  /// No description provided for @sleepTimer.
  ///
  /// In pt, this message translates to:
  /// **'Temporizador'**
  String get sleepTimer;

  /// No description provided for @sleepTimerSetFor.
  ///
  /// In pt, this message translates to:
  /// **'Temporizador configurado para'**
  String get sleepTimerSetFor;

  /// No description provided for @song.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get song;

  /// No description provided for @songInfo.
  ///
  /// In pt, this message translates to:
  /// **'Informações sobre a música'**
  String get songInfo;

  /// No description provided for @songPath.
  ///
  /// In pt, this message translates to:
  /// **'Caminho da música'**
  String get songPath;

  /// No description provided for @songs.
  ///
  /// In pt, this message translates to:
  /// **'Músicas'**
  String get songs;

  /// No description provided for @sorry.
  ///
  /// In pt, this message translates to:
  /// **'DESCULPE'**
  String get sorry;

  /// No description provided for @sponsor.
  ///
  /// In pt, this message translates to:
  /// **'Apoie este projeto'**
  String get sponsor;

  /// No description provided for @spotifyCharts.
  ///
  /// In pt, this message translates to:
  /// **'Paradas do Spotify'**
  String get spotifyCharts;

  /// No description provided for @spotifyPublic.
  ///
  /// In pt, this message translates to:
  /// **'Spotify Público'**
  String get spotifyPublic;

  /// No description provided for @spotifyTopCharts.
  ///
  /// In pt, this message translates to:
  /// **'Top Charts do Spotify'**
  String get spotifyTopCharts;

  /// No description provided for @stopDown.
  ///
  /// In pt, this message translates to:
  /// **'Parar Download'**
  String get stopDown;

  /// No description provided for @stopOnClose.
  ///
  /// In pt, this message translates to:
  /// **'Parar Música Quando o App for Fechado'**
  String get stopOnClose;

  /// No description provided for @stopOnCloseSub.
  ///
  /// In pt, this message translates to:
  /// **'Se desativado, a música não irá parar mesmo depois que o aplicativo estiver \'fechado\', até você clicar no botão de parar. Esta opção é para \'fechar\' o aplicativo, não quando o aplicativo está em \'plano de fundo\'. A música sempre tocará em segundo plano, você não precisa alterar nenhuma configuração para isso.\n'**
  String get stopOnCloseSub;

  /// No description provided for @streamQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade de Streaming'**
  String get streamQuality;

  /// No description provided for @streamQualitySub.
  ///
  /// In pt, this message translates to:
  /// **'Qualidades altas usam mais dados'**
  String get streamQualitySub;

  /// No description provided for @successTagEdit.
  ///
  /// In pt, this message translates to:
  /// **'Tags editadas com sucesso !'**
  String get successTagEdit;

  /// No description provided for @supportEq.
  ///
  /// In pt, this message translates to:
  /// **'Equalizador de Suporte'**
  String get supportEq;

  /// No description provided for @supportEqSub.
  ///
  /// In pt, this message translates to:
  /// **'Desligue se você não conseguir reproduzir músicas (no modo online e offline)'**
  String get supportEqSub;

  /// No description provided for @tg.
  ///
  /// In pt, this message translates to:
  /// **'Telegram'**
  String get tg;

  /// No description provided for @theme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Tema apagado!'**
  String get themeDeleted;

  /// No description provided for @themeSaved.
  ///
  /// In pt, this message translates to:
  /// **'Tema salvo!'**
  String get themeSaved;

  /// No description provided for @title.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get title;

  /// No description provided for @trendingSearch.
  ///
  /// In pt, this message translates to:
  /// **'Tendências do Momento'**
  String get trendingSearch;

  /// No description provided for @ui.
  ///
  /// In pt, this message translates to:
  /// **'Interface'**
  String get ui;

  /// No description provided for @undo.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get undo;

  /// No description provided for @unknown.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido(a)'**
  String get unknown;

  /// No description provided for @unlike.
  ///
  /// In pt, this message translates to:
  /// **'Não Gostei'**
  String get unlike;

  /// No description provided for @update.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get update;

  /// No description provided for @updateAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Atualização disponível!'**
  String get updateAvailable;

  /// No description provided for @upiCopied.
  ///
  /// In pt, this message translates to:
  /// **'UPI ID Copiado!'**
  String get upiCopied;

  /// No description provided for @useDenseMini.
  ///
  /// In pt, this message translates to:
  /// **'Miniplayer Compacto'**
  String get useDenseMini;

  /// No description provided for @useDenseMiniSub.
  ///
  /// In pt, this message translates to:
  /// **'A altura do miniplayer será reduzida'**
  String get useDenseMiniSub;

  /// No description provided for @useDominant.
  ///
  /// In pt, this message translates to:
  /// **'Use a cor dominante para Play Screen'**
  String get useDominant;

  /// No description provided for @useDominantSub.
  ///
  /// In pt, this message translates to:
  /// **'A cor dominante da imagem será usada para o fundo da tela de reprodução. Se desligado, o gradiente de fundo padrão será usado'**
  String get useDominantSub;

  /// No description provided for @useDown.
  ///
  /// In pt, this message translates to:
  /// **'Transmitir músicas baixadas, se disponível'**
  String get useDown;

  /// No description provided for @useDownSub.
  ///
  /// In pt, this message translates to:
  /// **'Se a música já estiver baixada a mesma será reproduzida em vez de streaming online'**
  String get useDownSub;

  /// No description provided for @useHome.
  ///
  /// In pt, this message translates to:
  /// **'Use a seção principal para obter melhor qualidade e suporte para download'**
  String get useHome;

  /// No description provided for @useProxy.
  ///
  /// In pt, this message translates to:
  /// **'Proxy'**
  String get useProxy;

  /// No description provided for @useProxySub.
  ///
  /// In pt, this message translates to:
  /// **'Ative esta opção se você não for da Índia e estiver tendo problemas com pesquisa, encontrando apenas músicas indianas ou não obtendo nenhum resultado, etc. Você pode até usar VPN com servidor indiano\n'**
  String get useProxySub;

  /// No description provided for @useSystemTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema do Sistema'**
  String get useSystemTheme;

  /// No description provided for @useVpn.
  ///
  /// In pt, this message translates to:
  /// **'Não é da Índia? Tente usar Proxy ou um VPN servidor indiano'**
  String get useVpn;

  /// No description provided for @version.
  ///
  /// In pt, this message translates to:
  /// **'Versão'**
  String get version;

  /// No description provided for @versionSub.
  ///
  /// In pt, this message translates to:
  /// **'Toque para procurar por atualizações'**
  String get versionSub;

  /// No description provided for @viewAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Ver Álbum'**
  String get viewAlbum;

  /// No description provided for @viewAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver Tudo'**
  String get viewAll;

  /// No description provided for @watchVideo.
  ///
  /// In pt, this message translates to:
  /// **'Ver Vídeo'**
  String get watchVideo;

  /// No description provided for @welcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem vindo'**
  String get welcome;

  /// No description provided for @willPlayNext.
  ///
  /// In pt, this message translates to:
  /// **'vai tocar a seguir'**
  String get willPlayNext;

  /// No description provided for @year.
  ///
  /// In pt, this message translates to:
  /// **'Ano'**
  String get year;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @yesReplace.
  ///
  /// In pt, this message translates to:
  /// **'Sim, mas substitua o antigo'**
  String get yesReplace;

  /// No description provided for @youTube.
  ///
  /// In pt, this message translates to:
  /// **'YouTube'**
  String get youTube;

  /// No description provided for @ytLiveAlert.
  ///
  /// In pt, this message translates to:
  /// **'Video está ao vivo ou ocorreu algum erro. Por favor espere até o vídeo acabar ou tente novamente.'**
  String get ytLiveAlert;

  /// No description provided for @useDominantFullScreen.
  ///
  /// In pt, this message translates to:
  /// **'Usar a cor dominante para toda a tela do reprodução'**
  String get useDominantFullScreen;

  /// No description provided for @useDominantFullScreenSub.
  ///
  /// In pt, this message translates to:
  /// **'A cor dominante da imagem será usada para o fundo da tela inteira do jogo. Disponível apenas se Usar dominante estiver ATIVADO'**
  String get useDominantFullScreenSub;

  /// No description provided for @favSongs.
  ///
  /// In pt, this message translates to:
  /// **'Músicas Favoritas'**
  String get favSongs;

  /// No description provided for @viewArtist.
  ///
  /// In pt, this message translates to:
  /// **'Ver Artista'**
  String get viewArtist;

  /// No description provided for @downFilename.
  ///
  /// In pt, this message translates to:
  /// **'Formato de Nome para Download'**
  String get downFilename;

  /// No description provided for @downFilenameSub.
  ///
  /// In pt, this message translates to:
  /// **'As músicas serão baixadas de acordo com este formato de nome de arquivo'**
  String get downFilenameSub;

  /// No description provided for @excluded.
  ///
  /// In pt, this message translates to:
  /// **'Excluídos'**
  String get excluded;

  /// No description provided for @excludedDetails.
  ///
  /// In pt, this message translates to:
  /// **'Músicas das pastas selecionadas não serão exibidas'**
  String get excludedDetails;

  /// No description provided for @includeExcludeFolder.
  ///
  /// In pt, this message translates to:
  /// **'Incluir/Excluir pastas'**
  String get includeExcludeFolder;

  /// No description provided for @includeExcludeFolderSub.
  ///
  /// In pt, this message translates to:
  /// **'Inclui/Exclui pastas selecionadas da seção «Minhas Músicas»'**
  String get includeExcludeFolderSub;

  /// No description provided for @included.
  ///
  /// In pt, this message translates to:
  /// **'Incluído'**
  String get included;

  /// No description provided for @includedDetails.
  ///
  /// In pt, this message translates to:
  /// **'Somente músicas das pastas selecionadas serão exibidas'**
  String get includedDetails;

  /// No description provided for @ytStreamQualitySub.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade superior usa mais dados'**
  String get ytStreamQualitySub;

  /// No description provided for @importResso.
  ///
  /// In pt, this message translates to:
  /// **'Importar da Resso'**
  String get importResso;

  /// No description provided for @ytDownQualitySub.
  ///
  /// In pt, this message translates to:
  /// **'Maior qualidade necessita mais espaço no disco'**
  String get ytDownQualitySub;

  /// No description provided for @getLyricsOnlineSub.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar online se as letras não estão disponíveis/baixadas para qualquer música offline'**
  String get getLyricsOnlineSub;

  /// No description provided for @getLyricsOnline.
  ///
  /// In pt, this message translates to:
  /// **'Letras de Músicas Locais'**
  String get getLyricsOnline;

  /// No description provided for @ytDownQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade de Download do YouTube'**
  String get ytDownQuality;

  /// No description provided for @ytStreamQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade de Streaming do YouTube'**
  String get ytStreamQuality;

  /// No description provided for @autoBackLocation.
  ///
  /// In pt, this message translates to:
  /// **'Local do Backup Automático'**
  String get autoBackLocation;

  /// No description provided for @useBlurForNowPlayingSub.
  ///
  /// In pt, this message translates to:
  /// **'Desfoque com uma opacidade mais baixa será usado como plano de fundo da seção de Tocando Agora'**
  String get useBlurForNowPlayingSub;

  /// No description provided for @useDominantAndDarkerColorsSub.
  ///
  /// In pt, this message translates to:
  /// **'A cor dominante e mais escura da imagem será usada como gradiente do fundo da tela de reprodução. Somente disponível se Cores Dominantes estiver ativado (Melhores resultados se cores dominantes para a tela inteira estiver ativado)'**
  String get useDominantAndDarkerColorsSub;

  /// No description provided for @useDominantAndDarkerColors.
  ///
  /// In pt, this message translates to:
  /// **'Usar cores dominantes e mais escuras na tela de reprodução'**
  String get useDominantAndDarkerColors;

  /// No description provided for @showPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Playlists na Tela Inicial'**
  String get showPlaylists;

  /// No description provided for @confirmViewable.
  ///
  /// In pt, this message translates to:
  /// **'Certifique-se que a playlist é visível'**
  String get confirmViewable;

  /// No description provided for @yourPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Suas Playlists'**
  String get yourPlaylists;

  /// No description provided for @upNext.
  ///
  /// In pt, this message translates to:
  /// **'A Seguir'**
  String get upNext;

  /// No description provided for @playerScreenBackgroundSub.
  ///
  /// In pt, this message translates to:
  /// **'O fundo selecionado será exibido na tela de reprodução'**
  String get playerScreenBackgroundSub;

  /// No description provided for @playerScreenBackground.
  ///
  /// In pt, this message translates to:
  /// **'Fundo da Tela de Reprodução'**
  String get playerScreenBackground;

  /// No description provided for @importJioSaavn.
  ///
  /// In pt, this message translates to:
  /// **'Importar do JioSaavn'**
  String get importJioSaavn;

  /// No description provided for @resetOnSkip.
  ///
  /// In pt, this message translates to:
  /// **'Repetir ao Pular Anterior'**
  String get resetOnSkip;

  /// No description provided for @resetOnSkipSub.
  ///
  /// In pt, this message translates to:
  /// **'Reproduzir desde o início ao invés de pular para a música anterior'**
  String get resetOnSkipSub;

  /// No description provided for @importPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Importar Playlist'**
  String get importPlaylist;

  /// No description provided for @mergePlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Mesclar Playlist'**
  String get mergePlaylists;

  /// No description provided for @playRadio.
  ///
  /// In pt, this message translates to:
  /// **'Tocar Rádio'**
  String get playRadio;

  /// No description provided for @top.
  ///
  /// In pt, this message translates to:
  /// **'Topo'**
  String get top;

  /// No description provided for @viral.
  ///
  /// In pt, this message translates to:
  /// **'Viral'**
  String get viral;

  /// No description provided for @openInSpotify.
  ///
  /// In pt, this message translates to:
  /// **'Abrir no Spotify'**
  String get openInSpotify;

  /// No description provided for @signInSpotify.
  ///
  /// In pt, this message translates to:
  /// **'Fazer Login no Spotify'**
  String get signInSpotify;

  /// No description provided for @topCharts.
  ///
  /// In pt, this message translates to:
  /// **'Paradas'**
  String get topCharts;

  /// No description provided for @cantFind.
  ///
  /// In pt, this message translates to:
  /// **'Não encontrou o que procurava? '**
  String get cantFind;

  /// No description provided for @radio.
  ///
  /// In pt, this message translates to:
  /// **'Rádio'**
  String get radio;

  /// No description provided for @shareLogs.
  ///
  /// In pt, this message translates to:
  /// **'Logs'**
  String get shareLogs;

  /// No description provided for @shareLogsSub.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar logs da sessão atual'**
  String get shareLogsSub;

  /// No description provided for @blacklistHomeSections.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar essa seção à blacklist'**
  String get blacklistHomeSections;

  /// No description provided for @blacklistHomeSectionsConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Você tem certeza que deseja adicionar essa seção à blacklist? Quando adicionada à blacklist, ela não será mostrada na tela inicial'**
  String get blacklistHomeSectionsConfirm;

  /// No description provided for @compactNotificationButtons.
  ///
  /// In pt, this message translates to:
  /// **'Botões de Notificações Compactos'**
  String get compactNotificationButtons;

  /// No description provided for @compactNotificationButtonsHeader.
  ///
  /// In pt, this message translates to:
  /// **'Você pode selecionar no máximo 3 botões'**
  String get compactNotificationButtonsHeader;

  /// No description provided for @mostPlayedSong.
  ///
  /// In pt, this message translates to:
  /// **'Música Mais Tocada'**
  String get mostPlayedSong;

  /// No description provided for @compactNotificationButtonsSub.
  ///
  /// In pt, this message translates to:
  /// **'Botões que devem ser mostrados na exibição de notificação compacta'**
  String get compactNotificationButtonsSub;

  /// No description provided for @folders.
  ///
  /// In pt, this message translates to:
  /// **'Pastas'**
  String get folders;

  /// No description provided for @songsPlayed.
  ///
  /// In pt, this message translates to:
  /// **'Músicas Tocadas'**
  String get songsPlayed;

  /// No description provided for @useLessDataImage.
  ///
  /// In pt, this message translates to:
  /// **'Menos Dados para Imagens'**
  String get useLessDataImage;

  /// No description provided for @minFourRequired.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo 4 necessário'**
  String get minFourRequired;

  /// No description provided for @useLessDataImageSub.
  ///
  /// In pt, this message translates to:
  /// **'Isso reduzirá a qualidade das imagens no app, porém vai economizar seus dados'**
  String get useLessDataImageSub;

  /// No description provided for @streamWifiQualitySub.
  ///
  /// In pt, this message translates to:
  /// **'Isso será usado sempre que o WiFi estiver conectado'**
  String get streamWifiQualitySub;

  /// No description provided for @noFileSelected.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum Arquivo Selecionado'**
  String get noFileSelected;

  /// No description provided for @restart.
  ///
  /// In pt, this message translates to:
  /// **'Talvez seja necessário reiniciar o app'**
  String get restart;

  /// No description provided for @volumeGestureEnabledSub.
  ///
  /// In pt, this message translates to:
  /// **'Deslize verticalmente na arte na tela do player para controlar o volume em vez de deslizar o player para baixo'**
  String get volumeGestureEnabledSub;

  /// No description provided for @showTopCharts.
  ///
  /// In pt, this message translates to:
  /// **'Top Charts'**
  String get showTopCharts;

  /// No description provided for @stats.
  ///
  /// In pt, this message translates to:
  /// **'Estatísticas'**
  String get stats;

  /// No description provided for @streamWifiQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade de Streaming (Wi-Fi)'**
  String get streamWifiQuality;

  /// No description provided for @showTopChartsSub.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar as principais Paradas do Spotify na tela inicial'**
  String get showTopChartsSub;

  /// No description provided for @volumeGestureEnabled.
  ///
  /// In pt, this message translates to:
  /// **'Volume por Gestos'**
  String get volumeGestureEnabled;

  /// No description provided for @restartRequired.
  ///
  /// In pt, this message translates to:
  /// **'Você precisa reiniciar o app'**
  String get restartRequired;

  /// No description provided for @openSource.
  ///
  /// In pt, this message translates to:
  /// **'Licenças de Código Aberto'**
  String get openSource;

  /// No description provided for @openSourceSub.
  ///
  /// In pt, this message translates to:
  /// **'Softwares de terceiros usados na construção do app'**
  String get openSourceSub;

  /// No description provided for @goodMorning.
  ///
  /// In pt, this message translates to:
  /// **'Bom dia,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In pt, this message translates to:
  /// **'Boa tarde,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In pt, this message translates to:
  /// **'Boa noite,'**
  String get goodEvening;

  /// No description provided for @topResult.
  ///
  /// In pt, this message translates to:
  /// **'Tendências do Momento'**
  String get topResult;

  /// No description provided for @podcasts.
  ///
  /// In pt, this message translates to:
  /// **'Podcasts'**
  String get podcasts;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
