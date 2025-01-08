# Сохраняем javax.annotation
-keep class javax.annotation.** { *; }
-dontwarn javax.annotation.**

# Сохраняем net.jcip
-keep class net.jcip.annotations.** { *; }
-dontwarn net.jcip.annotations.**

# Сохраняем javax.lang.model.element
-keep class javax.lang.model.element.** { *; }
-dontwarn javax.lang.model.element.**