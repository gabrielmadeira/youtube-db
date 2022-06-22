DROP VIEW IF EXISTS moviesfull; 

-- visão: tabela com todas as informações úteis sobre movies, ao invés
-- de ter que dar join para pegar informações das classes pais, essa
-- visão proporciona tudo em uma tabela só
CREATE VIEW moviesfull AS
  (SELECT *
   FROM movies
   NATURAL JOIN
     (SELECT *
      FROM videos
      NATURAL JOIN CONTENTS) AS video); 
	  	  
-- consulta 1 (utilizando visão)
-- id do filme, total arrecadado com filme de acordo com views e canal que lançou o vídeo
-- esse total é uma estimativa (não precisa) de quanto um filme já rendeu
-- considerando o preço como a média entre aluguel e compra do filme
-- multiplicado pelo número de views

SELECT views.id_video, count(*)*(((avg(moviesfull.price_buy)+avg(moviesfull.price_rent))/2)) AS total, ChannelsUsers.name as canal
FROM (VIEWS
JOIN moviesfull ON (moviesfull.id = views.id_video)) JOIN ChannelsUsers ON (moviesfull.id_channel = ChannelsUsers.id)
WHERE moviesfull.price_rent IS NOT NULL
AND moviesfull.price_buy IS NOT NULL
GROUP BY (views.id_video, ChannelsUsers.name);

-- consulta 2 (utilizando visão)
-- nome, preço, quantidade legendas e audios de filmes lançados antes de 2020 ordenados crescentemente por preços de compra
SELECT name,
       price_buy,
       sub.qtdsub,
       aud.qtdaud
FROM moviesfull
LEFT JOIN
(SELECT id_video AS id,
	  count(*) AS qtdSub
FROM subtitlesfilenames
GROUP BY id_video) AS sub
ON (sub.id=moviesfull.id)
LEFT JOIN
(SELECT id_video AS id,
	  count(*) AS qtdAud
FROM audiosfilenames
GROUP BY id_video) AS aud 
ON (aud.id=moviesfull.id)
WHERE creation_date_time < '2020-01-01 00:00:00'
ORDER BY price_buy; 

-- consulta 3 (usa group by)
-- o número de views por categoria
SELECT sum(aux.count) AS VIEWS,
       categories.name AS category
FROM
  (SELECT count(*),
          videos.id,
          videos.id_category
   FROM videos
   JOIN VIEWS ON (views.id_video = videos.id)
   GROUP BY videos.id) AS aux
JOIN categories ON (aux.id_category = categories.id)
GROUP BY categories.name; 


-- consulta 4 (usa group by)
-- indice de engajamento por categoria
-- vamos considerar engajamento a quantidade de ratings (tanto likes como dislikes)
-- dividido pelo número de views
SELECT (category_ratings.ratings/category_views.views) AS indice_engagement
FROM
  (SELECT sum(aux.count) AS VIEWS,
          categories.name AS category
   FROM
     (SELECT count(*),
             videos.id,
             videos.id_category
      FROM videos
      JOIN VIEWS ON (views.id_video = videos.id)
      GROUP BY videos.id) AS aux
   JOIN categories ON (aux.id_category = categories.id)
   GROUP BY categories.name) AS category_views
NATURAL JOIN
  (SELECT sum(aux.count) AS ratings,
          categories.name AS category
   FROM
     (SELECT count(*),
             videos.id,
             videos.id_category
      FROM videos
      JOIN ratings ON (ratings.id_content = videos.id)
      GROUP BY videos.id) AS aux
   JOIN categories ON (aux.id_category = categories.id)
   GROUP BY categories.name) AS category_ratings; 
   
   
-- consulta 5 (usa having)
-- nome dos usuários que publicaram 1h de video ou postaram pelo menos 3 coisas diferentes. Consulta para filtrar construtores de conteudo.
SELECT ChannelsUsers.name
FROM (ChannelsUsers
      JOIN CONTENTS ON (ChannelsUsers.id = id_channel))
LEFT JOIN Videos ON (Videos.id = Contents.id)
GROUP BY ChannelsUsers.name
HAVING SUM(Videos.duration) >= 3600
OR COUNT(*) >= 3; 


-- consulta 6 (c. usa TODOS)
--Retorna o nome do canal/usuário que já foi membro de todas as memberships de Jao Gameplay.
SELECT name
FROM ChannelsUsers C
WHERE NOT EXISTS
    (SELECT Memberships.id
     FROM Memberships
     JOIN ChannelsUsers ON (id_channel = ChannelsUsers.id)
     WHERE ChannelsUsers.name = 'Jao Gameplay'
       AND Memberships.id not in
         (SELECT Memberships.id AS ms
          FROM (ChannelsUsers
                JOIN Members ON (ChannelsUsers.id = Members.id_member))
          JOIN Memberships ON (Members.id_membership = Memberships.id)
          WHERE ChannelsUsers.id = C.id));
		  
		  
-- consulta 7
-- Todos os vídeos e quais audios/legendas temdisponiveis
SELECT Videos.name, Dub.display_name as Dubs, Sub.display_name as Subs
FROM Videos LEFT JOIN AudiosFilenames as Dub ON (Videos.id = Dub.id_video) 
FULL JOIN SubtitlesFilenames as Sub ON (Videos.id = Sub.id_video and Dub.display_name = Sub.Display_name);

-- consulta 8
-- nome do usuário e corpo de todos os comentários de todos os vídeos do canal de id 0
SELECT channelsusers.name,
	 content
FROM comments
JOIN channelsusers ON (comments.id_user = channelsusers.id) WHERE id_content in
(SELECT id
 FROM CONTENTS
 WHERE id_channel=0); 
	 
-- consulta 9
-- número de likes por conteúdo
SELECT Contents.id as id_conteudo, COUNT(distinct(ChannelsUsers.id)) as number_of_likes
FROM Contents JOIN Ratings ON (Contents.id = Ratings.id_content) JOIN ChannelsUsers ON (ChannelsUsers.id = Ratings.id_user)
WHERE rating = TRUE
GROUP BY Contents.id;

-- consulta 10
-- tempo assistido por categoria
SELECT Categories.name AS category,
	 AVG(stop_time) AS watch_time
FROM Videos
JOIN VIEWS ON (id_video = Videos.id)
JOIN Categories ON (categories.id = id_category) WHERE stop_time IS NOT NULL
GROUP BY Categories.name;
