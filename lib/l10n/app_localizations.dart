import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Hunar Bazaar'**
  String get appName;

  /// No description provided for @handmadeInPakistan.
  ///
  /// In en, this message translates to:
  /// **'HANDMADE IN PAKISTAN'**
  String get handmadeInPakistan;

  /// No description provided for @verifiedMaker.
  ///
  /// In en, this message translates to:
  /// **'Verified maker'**
  String get verifiedMaker;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved items'**
  String get saved;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navMakers.
  ///
  /// In en, this message translates to:
  /// **'Makers'**
  String get navMakers;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get navSell;

  /// No description provided for @sellerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get sellerHome;

  /// No description provided for @sellerListings.
  ///
  /// In en, this message translates to:
  /// **'Listings'**
  String get sellerListings;

  /// No description provided for @sellerOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sellerOrders;

  /// No description provided for @sellerMyShop.
  ///
  /// In en, this message translates to:
  /// **'My shop'**
  String get sellerMyShop;

  /// No description provided for @makerRukhsana.
  ///
  /// In en, this message translates to:
  /// **'Rukhsana'**
  String get makerRukhsana;

  /// No description provided for @makerRukhsanaBibi.
  ///
  /// In en, this message translates to:
  /// **'Rukhsana Bibi'**
  String get makerRukhsanaBibi;

  /// No description provided for @makerZainab.
  ///
  /// In en, this message translates to:
  /// **'Zainab'**
  String get makerZainab;

  /// No description provided for @shopRukhsana.
  ///
  /// In en, this message translates to:
  /// **'Rukhsana\'s Phulkari'**
  String get shopRukhsana;

  /// No description provided for @cityMultan.
  ///
  /// In en, this message translates to:
  /// **'Multan'**
  String get cityMultan;

  /// No description provided for @cityMultanPunjab.
  ///
  /// In en, this message translates to:
  /// **'Multan, Punjab'**
  String get cityMultanPunjab;

  /// No description provided for @cityHala.
  ///
  /// In en, this message translates to:
  /// **'Hala'**
  String get cityHala;

  /// No description provided for @cityLahore.
  ///
  /// In en, this message translates to:
  /// **'Lahore'**
  String get cityLahore;

  /// No description provided for @cityKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get cityKarachi;

  /// No description provided for @cityIslamabad.
  ///
  /// In en, this message translates to:
  /// **'Islamabad'**
  String get cityIslamabad;

  /// No description provided for @buyerAyesha.
  ///
  /// In en, this message translates to:
  /// **'Ayesha'**
  String get buyerAyesha;

  /// No description provided for @buyerSana.
  ///
  /// In en, this message translates to:
  /// **'Sana'**
  String get buyerSana;

  /// No description provided for @buyerMehreen.
  ///
  /// In en, this message translates to:
  /// **'Mehreen'**
  String get buyerMehreen;

  /// No description provided for @craftPhulkari.
  ///
  /// In en, this message translates to:
  /// **'Phulkari'**
  String get craftPhulkari;

  /// No description provided for @craftAjrak.
  ///
  /// In en, this message translates to:
  /// **'Ajrak'**
  String get craftAjrak;

  /// No description provided for @craftRalli.
  ///
  /// In en, this message translates to:
  /// **'Ralli'**
  String get craftRalli;

  /// No description provided for @craftBluePottery.
  ///
  /// In en, this message translates to:
  /// **'Blue pottery'**
  String get craftBluePottery;

  /// No description provided for @craftSindhi.
  ///
  /// In en, this message translates to:
  /// **'Sindhi embroidery'**
  String get craftSindhi;

  /// No description provided for @craftOther.
  ///
  /// In en, this message translates to:
  /// **'+ Other'**
  String get craftOther;

  /// No description provided for @handEmbroidery.
  ///
  /// In en, this message translates to:
  /// **'Hand embroidery'**
  String get handEmbroidery;

  /// No description provided for @productDupattaShort.
  ///
  /// In en, this message translates to:
  /// **'Phulkari dupatta, hand-embroidered'**
  String get productDupattaShort;

  /// No description provided for @productDupattaFull.
  ///
  /// In en, this message translates to:
  /// **'Phulkari dupatta, hand-embroidered on khaddar'**
  String get productDupattaFull;

  /// No description provided for @productDupatta.
  ///
  /// In en, this message translates to:
  /// **'Phulkari dupatta'**
  String get productDupatta;

  /// No description provided for @productAjrakShawl.
  ///
  /// In en, this message translates to:
  /// **'Ajrak shawl, block-printed'**
  String get productAjrakShawl;

  /// No description provided for @productCushion.
  ///
  /// In en, this message translates to:
  /// **'Bagh cushion cover'**
  String get productCushion;

  /// No description provided for @productShawl.
  ///
  /// In en, this message translates to:
  /// **'Phulkari shawl'**
  String get productShawl;

  /// No description provided for @productPotli.
  ///
  /// In en, this message translates to:
  /// **'Embroidered potli'**
  String get productPotli;

  /// No description provided for @byMaker.
  ///
  /// In en, this message translates to:
  /// **'by {name} · {city}'**
  String byMaker(String name, String city);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search phulkari, ajrak, ralli…'**
  String get searchHint;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy directly from the women who make it'**
  String get heroTitle;

  /// No description provided for @meetMakers.
  ///
  /// In en, this message translates to:
  /// **'Meet the makers →'**
  String get meetMakers;

  /// No description provided for @shopByCraft.
  ///
  /// In en, this message translates to:
  /// **'Shop by craft'**
  String get shopByCraft;

  /// No description provided for @newFromMakers.
  ///
  /// In en, this message translates to:
  /// **'New from makers'**
  String get newFromMakers;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @ratingReviews.
  ///
  /// In en, this message translates to:
  /// **'4.9 · 32 reviews'**
  String get ratingReviews;

  /// No description provided for @chipHandEmbroidered.
  ///
  /// In en, this message translates to:
  /// **'Hand-embroidered'**
  String get chipHandEmbroidered;

  /// No description provided for @hoursOfWork.
  ///
  /// In en, this message translates to:
  /// **'{n} hours of work'**
  String hoursOfWork(String n);

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get cashOnDelivery;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by'**
  String get madeBy;

  /// No description provided for @verifiedYears.
  ///
  /// In en, this message translates to:
  /// **'Verified maker · 22 years of phulkari'**
  String get verifiedYears;

  /// No description provided for @theStory.
  ///
  /// In en, this message translates to:
  /// **'The story'**
  String get theStory;

  /// No description provided for @storyText.
  ///
  /// In en, this message translates to:
  /// **'Soft khaddar cotton, embroidered by hand with silk thread in the Punjabi bagh style. Each star is stitched one by one, so no two pieces are the same.'**
  String get storyText;

  /// No description provided for @orderOnWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Order on WhatsApp'**
  String get orderOnWhatsApp;

  /// No description provided for @deliveryIn.
  ///
  /// In en, this message translates to:
  /// **'Delivery in 3–5 days'**
  String get deliveryIn;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @removeSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get removeSaved;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @followShop.
  ///
  /// In en, this message translates to:
  /// **'Follow shop'**
  String get followShop;

  /// No description provided for @voiceQuote.
  ///
  /// In en, this message translates to:
  /// **'\"My mother taught me phulkari when I was ten. Every piece carries her stitches.\"'**
  String get voiceQuote;

  /// No description provided for @playVoice.
  ///
  /// In en, this message translates to:
  /// **'Play maker\'s voice note'**
  String get playVoice;

  /// No description provided for @productsTab.
  ///
  /// In en, this message translates to:
  /// **'Products · {n}'**
  String productsTab(String n);

  /// No description provided for @reviewsTab.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTab;

  /// No description provided for @aboutTab.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTab;

  /// No description provided for @soldCount.
  ///
  /// In en, this message translates to:
  /// **'{n} sold'**
  String soldCount(String n);

  /// No description provided for @sellTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell your craft to all of Pakistan'**
  String get sellTitle;

  /// No description provided for @sellTagline.
  ///
  /// In en, this message translates to:
  /// **'اپنا ہنر پورے پاکستان تک پہنچائیں'**
  String get sellTagline;

  /// No description provided for @sellStep1.
  ///
  /// In en, this message translates to:
  /// **'One photo makes your listing'**
  String get sellStep1;

  /// No description provided for @sellStep2.
  ///
  /// In en, this message translates to:
  /// **'We help you set a fair price'**
  String get sellStep2;

  /// No description provided for @sellStep3.
  ///
  /// In en, this message translates to:
  /// **'Buyers order on WhatsApp'**
  String get sellStep3;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @startSelling.
  ///
  /// In en, this message translates to:
  /// **'Start selling'**
  String get startSelling;

  /// No description provided for @setUpShop.
  ///
  /// In en, this message translates to:
  /// **'Set up your shop'**
  String get setUpShop;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopName;

  /// No description provided for @yourCraft.
  ///
  /// In en, this message translates to:
  /// **'Your craft'**
  String get yourCraft;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @addPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo of you or your hands at work'**
  String get addPhotoTitle;

  /// No description provided for @addPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Buyers trust shops with a maker photo.'**
  String get addPhotoHint;

  /// No description provided for @openMyShop.
  ///
  /// In en, this message translates to:
  /// **'Open my shop'**
  String get openMyShop;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Assalam-o-alaikum, Rukhsana'**
  String get greeting;

  /// No description provided for @viewShop.
  ///
  /// In en, this message translates to:
  /// **'View shop'**
  String get viewShop;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @ordersLabel.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersLabel;

  /// No description provided for @shopViews.
  ///
  /// In en, this message translates to:
  /// **'Shop views'**
  String get shopViews;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add a new product'**
  String get addNewProduct;

  /// No description provided for @onePhoto.
  ///
  /// In en, this message translates to:
  /// **'One photo, about 2 minutes'**
  String get onePhoto;

  /// No description provided for @buyersWaiting.
  ///
  /// In en, this message translates to:
  /// **'Buyers waiting for you'**
  String get buyersWaiting;

  /// No description provided for @nNew.
  ///
  /// In en, this message translates to:
  /// **'{n} new'**
  String nNew(String n);

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @msgAyesha.
  ///
  /// In en, this message translates to:
  /// **'Is the phulkari dupatta available?'**
  String get msgAyesha;

  /// No description provided for @msgSana.
  ///
  /// In en, this message translates to:
  /// **'Can you make it in green?'**
  String get msgSana;

  /// No description provided for @yourListings.
  ///
  /// In en, this message translates to:
  /// **'Your listings'**
  String get yourListings;

  /// No description provided for @seeAllN.
  ///
  /// In en, this message translates to:
  /// **'See all {n}'**
  String seeAllN(String n);

  /// No description provided for @priceViews.
  ///
  /// In en, this message translates to:
  /// **'{price} · {n} views'**
  String priceViews(String price, String n);

  /// No description provided for @stepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 4 · Photos'**
  String get stepPhotos;

  /// No description provided for @photoHint.
  ///
  /// In en, this message translates to:
  /// **'Daylight · lay it flat · show the whole piece'**
  String get photoHint;

  /// No description provided for @addUpTo.
  ///
  /// In en, this message translates to:
  /// **'Add up to 5 photos: whole piece, close-up of stitches, worn or in use'**
  String get addUpTo;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @maxPhotos.
  ///
  /// In en, this message translates to:
  /// **'You can add up to 5 photos.'**
  String get maxPhotos;

  /// No description provided for @writingTitle.
  ///
  /// In en, this message translates to:
  /// **'Writing your listing…'**
  String get writingTitle;

  /// No description provided for @writingUrdu.
  ///
  /// In en, this message translates to:
  /// **'آپ کی لسٹنگ تیار ہو رہی ہے'**
  String get writingUrdu;

  /// No description provided for @aiCheck1.
  ///
  /// In en, this message translates to:
  /// **'Found: phulkari dupatta, khaddar cotton'**
  String get aiCheck1;

  /// No description provided for @aiCheck2.
  ///
  /// In en, this message translates to:
  /// **'Writing the title and story in Urdu & English'**
  String get aiCheck2;

  /// No description provided for @aiCheck3.
  ///
  /// In en, this message translates to:
  /// **'Getting your price ready'**
  String get aiCheck3;

  /// No description provided for @writtenByAi.
  ///
  /// In en, this message translates to:
  /// **'Written by Gemini AI · you can change everything next'**
  String get writtenByAi;

  /// No description provided for @skipWrite.
  ///
  /// In en, this message translates to:
  /// **'Skip and write it myself'**
  String get skipWrite;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 4 · Details'**
  String get stepDetails;

  /// No description provided for @aiNote.
  ///
  /// In en, this message translates to:
  /// **'Fields marked AI were written for you. Tap to change.'**
  String get aiNote;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @categoryValue.
  ///
  /// In en, this message translates to:
  /// **'Phulkari › Dupattas'**
  String get categoryValue;

  /// No description provided for @fieldStory.
  ///
  /// In en, this message translates to:
  /// **'The story'**
  String get fieldStory;

  /// No description provided for @writeAgain.
  ///
  /// In en, this message translates to:
  /// **'↻ Write again'**
  String get writeAgain;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'▶ Listen'**
  String get listen;

  /// No description provided for @detailMaterial.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get detailMaterial;

  /// No description provided for @detailMaterialValue.
  ///
  /// In en, this message translates to:
  /// **'Khaddar cotton, silk thread'**
  String get detailMaterialValue;

  /// No description provided for @detailTechnique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get detailTechnique;

  /// No description provided for @detailTechniqueValue.
  ///
  /// In en, this message translates to:
  /// **'Hand embroidery (bagh)'**
  String get detailTechniqueValue;

  /// No description provided for @detailSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get detailSize;

  /// No description provided for @detailSizeValue.
  ///
  /// In en, this message translates to:
  /// **'2.5 m × 1 m'**
  String get detailSizeValue;

  /// No description provided for @nextSetPrice.
  ///
  /// In en, this message translates to:
  /// **'Next: set the price'**
  String get nextSetPrice;

  /// No description provided for @stepPrice.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 4 · Price'**
  String get stepPrice;

  /// No description provided for @tellByVoice.
  ///
  /// In en, this message translates to:
  /// **'Tell by voice'**
  String get tellByVoice;

  /// No description provided for @materialsCost.
  ///
  /// In en, this message translates to:
  /// **'Materials cost'**
  String get materialsCost;

  /// No description provided for @clothThread.
  ///
  /// In en, this message translates to:
  /// **'Cloth + thread'**
  String get clothThread;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time spent'**
  String get timeSpent;

  /// No description provided for @daysN.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 day} other{{n} days}}'**
  String daysN(int n);

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get less;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @worthTitle.
  ///
  /// In en, this message translates to:
  /// **'What your work is worth'**
  String get worthTitle;

  /// No description provided for @aiAssisted.
  ///
  /// In en, this message translates to:
  /// **'AI-ASSISTED'**
  String get aiAssisted;

  /// No description provided for @lowLabel.
  ///
  /// In en, this message translates to:
  /// **'Low · {price}'**
  String lowLabel(String price);

  /// No description provided for @fairLabel.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fairLabel;

  /// No description provided for @highLabel.
  ///
  /// In en, this message translates to:
  /// **'High · {price}'**
  String highLabel(String price);

  /// No description provided for @breakdownMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get breakdownMaterials;

  /// No description provided for @yourTime.
  ///
  /// In en, this message translates to:
  /// **'Your time · {h} h × {rate}'**
  String yourTime(String h, String rate);

  /// No description provided for @handValue.
  ///
  /// In en, this message translates to:
  /// **'Hand-embroidery value'**
  String get handValue;

  /// No description provided for @listenWhy.
  ///
  /// In en, this message translates to:
  /// **'▶ Listen to why'**
  String get listenWhy;

  /// No description provided for @yourPrice.
  ///
  /// In en, this message translates to:
  /// **'Your price'**
  String get yourPrice;

  /// No description provided for @youDecide.
  ///
  /// In en, this message translates to:
  /// **'You always decide'**
  String get youDecide;

  /// No description provided for @nextPreview.
  ///
  /// In en, this message translates to:
  /// **'Next: preview'**
  String get nextPreview;

  /// No description provided for @stepPreview.
  ///
  /// In en, this message translates to:
  /// **'Step 4 of 4 · Preview'**
  String get stepPreview;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Your WhatsApp catalog card'**
  String get catalogTitle;

  /// No description provided for @catalogByline.
  ///
  /// In en, this message translates to:
  /// **'By {name} · {city} · Order on WhatsApp'**
  String catalogByline(String name, String city);

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'New in my shop: hand-embroidered phulkari dupatta, {price}. Cash on delivery across Pakistan. Reply to order.'**
  String shareMessage(String price);

  /// No description provided for @publishShare.
  ///
  /// In en, this message translates to:
  /// **'Publish & share on WhatsApp'**
  String get publishShare;

  /// No description provided for @publishOnly.
  ///
  /// In en, this message translates to:
  /// **'Publish to the Bazaar only'**
  String get publishOnly;

  /// No description provided for @liveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your dupatta is live'**
  String get liveTitle;

  /// No description provided for @liveUrdu.
  ///
  /// In en, this message translates to:
  /// **'آپ کا دوپٹہ بازار میں آ گیا ہے'**
  String get liveUrdu;

  /// No description provided for @liveSub.
  ///
  /// In en, this message translates to:
  /// **'Buyers can now find it in the Bazaar and on WhatsApp.'**
  String get liveSub;

  /// No description provided for @yourShopLink.
  ///
  /// In en, this message translates to:
  /// **'Your shop link'**
  String get yourShopLink;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Get your first order faster'**
  String get tipsTitle;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Share the card in 3 WhatsApp groups'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Add a close-up photo of the stitches'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Record a 15-second \"meet the maker\" note'**
  String get tip3;

  /// No description provided for @addAnother.
  ///
  /// In en, this message translates to:
  /// **'Add another product'**
  String get addAnother;

  /// No description provided for @backDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backDashboard;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @tabNew.
  ///
  /// In en, this message translates to:
  /// **'New · {n}'**
  String tabNew(String n);

  /// No description provided for @tabToSend.
  ///
  /// In en, this message translates to:
  /// **'To send · {n}'**
  String tabToSend(String n);

  /// No description provided for @tabDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered · {n}'**
  String tabDelivered(String n);

  /// No description provided for @earnedIn.
  ///
  /// In en, this message translates to:
  /// **'Earned in November'**
  String get earnedIn;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time · {price}'**
  String allTime(String price);

  /// No description provided for @cashNote.
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery · you receive the money from the courier'**
  String get cashNote;

  /// No description provided for @chatWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Chat on WhatsApp'**
  String get chatWhatsApp;

  /// No description provided for @acceptOrder.
  ///
  /// In en, this message translates to:
  /// **'Accept order'**
  String get acceptOrder;

  /// No description provided for @whenToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get whenToday;

  /// No description provided for @whenYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get whenYesterday;

  /// No description provided for @orderMeta.
  ///
  /// In en, this message translates to:
  /// **'{buyer} · {city} · {when}'**
  String orderMeta(String buyer, String city, String when);

  /// No description provided for @earningsChart.
  ///
  /// In en, this message translates to:
  /// **'Earnings for the last 6 months, rising'**
  String get earningsChart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
