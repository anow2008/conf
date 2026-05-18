#!/bin/sh

# 1. إعدادات المسارات والبيانات
OSCAM_PATH="/etc/tuxbox/config"
USER="anow2008"
REPO="conf"
BRANCH="main"

echo "-------------------------------------------------------"
echo "    جاري إيقاف واجهة Enigma2 مؤقتاً لتجنب أي تعليق..."
echo "-------------------------------------------------------"

# إيقاف الواجهة بالكامل
init 4
sleep 2 # ثواني بسيطة للتأكد إن الواجهة قفلت مستقرة

echo "-------------------------------------------------------"
echo "    جاري فحص مستودع GitHub وتحديث ملفاتك أوتوماتيكياً"
echo "-------------------------------------------------------"

# 2. جلب الملفات فقط وتجنب الفولدرات (مع حماية ضد تعليق الشبكة)
FILES=$(wget -qO- --timeout=5 --tries=2 "https://api.github.com/repos/$USER/$REPO/contents?ref=$BRANCH" | \
grep -B 1 '"type": "file"' | grep '"name":' | sed 's/.*"name": "\(.*\)".*/\1/' | \
grep -v "install" | grep -v ".github" | grep -v "README.md")

# التأكد إن فيه ملفات رجعت قبل ما نكمل
if [ -z "$FILES" ]; then
    echo "❌ فشل في جلب قائمة الملفات أو المستودع فارغ."
    echo "⚙️ جاري إعادة تشغيل واجهة Enigma2..."
    init 3
    exit 1
fi

# 3. حلقة تحميل الملفات
for FILE in $FILES; do
    echo "⬇️ جاري تحميل وتحديث: $FILE ..."
    wget -q --timeout=5 --tries=2 "-O" "$OSCAM_PATH/$FILE" "https://raw.githubusercontent.com/$USER/$REPO/$BRANCH/$FILE"
done

# 4. ضبط التصاريح (Permissions)
echo "⚙️ جاري ضبط تصاريح الملفات (644)..."
chmod 644 $OSCAM_PATH/oscam.* 2>/dev/null
chmod 644 $OSCAM_PATH/ncam.* 2>/dev/null
chmod 644 $OSCAM_PATH/constant.cw 2>/dev/null
chmod 644 $OSCAM_PATH/*.key 2>/dev/null

echo "-------------------------------------------------------"
echo "✅ تم التحديث بنجاح! جاري إعادة تشغيل واجهة Enigma2 الآن..."
echo "-------------------------------------------------------"

# 5. إعادة تشغيل واجهة الجهاز
init 3
