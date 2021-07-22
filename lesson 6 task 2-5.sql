USE vk2;

-- 2 задание:Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- все запросы на дружбу от пользователя
SELECT * from friend_requests where from_user_id = 5;

-- все запросы на дружбу пользователю
SELECT * from friend_requests where to_user_id = 5;

-- находим всех друзей пользователя
SELECT to_user_id FROM friend_requests WHERE from_user_id = 5
	UNION
SELECT from_user_id FROM friend_requests WHERE to_user_id = 5;

-- пользователи с которыми переписывался наш пользователь
SELECT from_user_id, to_user_id FROM messages where from_user_id = 5 group by to_user_id ;

-- сколько всего сообщений отправил пользователь
SELECT count(*), from_user_id FROM messages where from_user_id = 5;

-- считаем количество входящих и исходящих сообщений пользователя с любыми пользователями
SELECT COUNT(*) as number_messages, from_user_id as our_user, to_user_id as best_friend
FROM messages
where from_user_id = 5 or to_user_id = 5
GROUP BY from_user_id, to_user_id
order by number_messages desc limit 10;

-- результат (пользователь 57 не включился в список так как не в списке друзей)
SELECT COUNT(*) as number_messages, from_user_id as our_user, to_user_id as best_friend
FROM messages
where from_user_id = 5 and to_user_id in 
(SELECT to_user_id FROM friend_requests WHERE from_user_id = 5
	UNION
SELECT from_user_id FROM friend_requests WHERE to_user_id = 5)
GROUP BY from_user_id, to_user_id
order by number_messages desc limit 1;

-- 3 задание: Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.

-- id 10 самых молодых пользователей
SELECT user_id from profiles order by birthday desc limit 10;
SELECT user_id, birthday from profiles order by birthday desc limit 10;

-- количество лайков конкретного пользователя
SELECT count(user_id) from posts_likes where user_id = 31;
SELECT count(user_id) from posts_likes where user_id in (23,78,100,44,65,56,47,20,5,31);

-- количество лайков 10 самых молодых пользователей (выскакивает ошибка использования невозможности использования подзапроса в in)
-- SELECT count(user_id) from posts_likes where user_id in (SELECT user_id from profiles order by birthday desc limit 10);

-- все посты конкретного пользователя
select id from posts where user_id = 1;

-- считаем количество лайков всех постов конкретного пользователя
select count(post_id) from posts_likes where post_id in (select id from posts where user_id = 1);

-- результат вместо выбора конкретного пользователя будем выбирать его из списка пользователей
select count(post_id) from posts_likes where post_id in (select id from posts where user_id in (select user_id from (SELECT user_id from profiles order by birthday desc limit 10) as youngest_10));


-- 4 задание: Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- считаем количество женщин и мужчин 
SELECT count(gender) from profiles where gender = 'm';
SELECT count(gender) from profiles where gender = 'f';

-- выводим user_id всех мужчин
select user_id from profiles where gender = 'm';

-- подсчитываем сколько лайков поставили мужчины и женщины
select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'm');
select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'f');

-- объединяем оба запроса (нагляднее видно у кого больше)
select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'm')
union 
select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'f');

-- результирующий запрос
select if ((select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'm')) 
> (select count(user_id) from posts_likes where user_id in (select user_id from profiles where gender = 'f')), 'мужчины','женщины') as most_likes_gender;

-- 5 задание: Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

select count(*) as act, from_user_id as user_id from friend_requests group by user_id
union
select count(*) as act, from_user_id as user_id from messages group by user_id
union
select count(*) as act, user_id as user_id from posts_likes group by user_id;

select sum(act) as activity, user_id from (
	select count(*) as act, from_user_id as user_id from friend_requests group by user_id
	union
	select count(*) as act, from_user_id as user_id from messages group by user_id
	union
	select count(*) as act, user_id as user_id from posts_likes group by user_id) 
	as count_activity
group by user_id order by activity limit 10;


























