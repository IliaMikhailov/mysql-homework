-- 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
HSET ip_count 127.0.0.1 1

-- 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
SET Ilia Ilia@gmail.com
SET Ilia@gmail.com Ilia
GET Ilia
GET Ilia@gmail.com

-- 3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
db.shop.insert({category: 'клавиатура'})
db.shop.insert({category: 'мышь'})

db.shop.update({category: 'клавиатура'}, {$set: { products:['проводная клавиатура HP', 'беспроводная клавиатура HP'] }})
db.shop.update({category: 'мышь'}, {$set: { products:['беспроводная мышка Razor', 'беспроводная мышка logitech', 'проводная мышка HP'] }})
