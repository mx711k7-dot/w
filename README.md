# Secure VPN App

تطبيق VPN احترافي بـ 33 سيرفر عالمي مع واجهة مستخدم جميلة وسهلة الاستخدام.

## المميزات

- **33 سيرفر** من مختلف دول العالم
- واجهة مستخدم عربية جميلة باللون الأخضر السيبراني
- خريطة عالمية تفاعلية
- إحصائيات الاتصال في الوقت الفعلي
- بحث في السيرفرات
- تصميم داكن أنيق

## متطلبات التشغيل

- Flutter SDK 3.10+
- Dart 3.0+
- Android SDK 21+

## كيفية البناء

### 1. تثبيت Flutter

تأكد من تثبيت Flutter SDK:
```bash
flutter doctor
```

### 2. تحديث ملف local.properties

افتح الملف `android/local.properties` وحدد مسار Flutter SDK لديك:
```
flutter.sdk=C:\flutter
```

### 3. تثبيت الحزم

```bash
cd vpn_app
flutter pub get
```

### 4. بناء التطبيق

```bash
flutter build apk --release
```

سيتم إنشاء ملف APK في:
```
build/app/outputs/flutter-apk/app-release.apk
```

## السيرفرات المتاحة

| الدولة | المدينة | الملف |
|--------|---------|-------|
| الجزائر | الجزائر | Algeria_PIA_154.ovpn |
| البحرين | المنامة | Bahrain_-_Manama_388.ovpn |
| البرازيل | ساو باولو | Brazil_PIA_169.ovpn |
| كندا | مونتريال | Canada_-_Montreal_PIA_171.ovpn |
| الصين | بكين | China_PIA_177.ovpn |
| قبرص | نيقوسيا | Cyprus_PIA_181.ovpn |
| مصر | القاهرة | Egypt_PIA_187.ovpn |
| فرنسا | باريس | France_PIA_192.ovpn |
| الهند | مومباي | India_PIA_200.ovpn |
| إسرائيل | تل أبيب | Israel_PIA_204.ovpn |
| اليابان | طوكيو | Japan_-_Tokyo_442.ovpn |
| المغرب | الدار البيضاء | Morocco_PIA_220.ovpn |
| هولندا | أمستردام | Netherlands_-_Amsterdam_424.ovpn |
| بولندا | وارسو | Poland_-_Warsaw_426.ovpn |
| البرتغال | لشبونة | Portugal_-_Lisbon_427.ovpn |
| قطر | الدوحة | Qatar_PIA_232.ovpn |
| السعودية | الرياض | Saudi_Arabia_PIA_234.ovpn |
| سنغافورة | سنغافورة | Singapore_-_Singapore_445.ovpn |
| جنوب أفريقيا | جوهانسبرغ | South_Africa_-_Johannesburg_451.ovpn |
| كوريا الجنوبية | سيول | South_Korea_-_Seoul_443.ovpn |
| إسبانيا | مدريد | Spain_-_Madrid_432.ovpn |
| سويسرا | زيورخ | Switzerland_-_Zurich_434.ovpn |
| تركيا | إسطنبول | Turkey_-_Istanbul_435.ovpn |
| الإمارات | دبي | UAE_PIA_250.ovpn |
| أوكرانيا | كييف | Ukraine_-_Kyiv_436.ovpn |
| المملكة المتحدة | لندن | United_Kingdom_-_London_438.ovpn |
| الولايات المتحدة | نيوجيرسي | United_States_-_New_Jersey_403.ovpn |
| الولايات المتحدة 2 | داكوتا الجنوبية | United_States_-_South_Dakota_PIA_294.ovpn |
| الولايات المتحدة 3 | تكساس | United_States_-_Texas_PIA_296.ovpn |

## الترخيص

MIT License
