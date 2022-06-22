-- Youtube - Trabalho Prático
-- Fundamentos de Banco de Dados 2021/2
-- Instituto de Informática - Universidade Federal do Rio Grande do Sul
-- Gabriel Madeira (00322863)
-- Henrique Borges (00326970)


drop table if exists CommentsOfComments;
drop table if exists CommentsOnContents;
drop table if exists CommentsJudgements;
drop table if exists StaticComments;
drop table if exists Comments;
drop table if exists Listings;
drop table if exists PlaylistSaves;
drop table if exists Playlists;
drop table if exists PriveledgedAccess;
drop table if exists Ratings;
drop table if exists Views;
drop table if exists AudiosFilenames;
drop table if exists SubtitlesFilenames;
drop view if exists moviesfull;
drop table if exists Movies;
drop table if exists Videos;
drop table if exists Posts;
drop table if exists Contents;
drop table if exists Categories;
drop table if exists Members;
drop table if exists Badges;
drop table if exists Memberships;
drop table if exists Subscriptions;
drop table if exists ChannelsUsers;
drop table if exists GoogleAccounts;

CREATE TABLE GoogleAccounts
(email VARCHAR(255) NOT NULL PRIMARY KEY);

INSERT INTO GoogleAccounts VALUES ('joao123@gmail.com');
INSERT INTO GoogleAccounts VALUES ('marcio321@gmail.com');
INSERT INTO GoogleAccounts VALUES ('janaina444@gmail.com');
INSERT INTO GoogleAccounts VALUES ('youtubemovies@gmail.com');

CREATE TABLE ChannelsUsers
(id SERIAL PRIMARY KEY,
 name VARCHAR(255) NOT NULL,	
 join_date TIMESTAMP NOT NULL,	
 email VARCHAR(255) NOT NULL,
 pfp_filename VARCHAR(300) NOT NULL UNIQUE,
 cover_image_filename VARCHAR(300) UNIQUE,
 description VARCHAR(5000),	
 FOREIGN KEY (email) REFERENCES GoogleAccounts(email));
 
INSERT INTO ChannelsUsers VALUES (0, 'Jao Gameplay', '2020-10-05 14:01:10-08', 'joao123@gmail.com', 'profile_picture-joao123@gmail.com-0.jpg', 'cover_image-joao123@gmail.com-0.jpg', 'Vídeos novos toda semana!');
INSERT INTO ChannelsUsers VALUES (1, 'Marcio Gonçalvez', '2019-11-10 10:07:10-08', 'marcio321@gmail.com', 'profile_picture-marcio321@gmail.com-0.jpg', NULL, 'Uso pessoal');
INSERT INTO ChannelsUsers VALUES (2, 'Janaina Vlogs', '2018-09-02 11:01:10-08', 'janaina444@gmail.com', 'profile_picture-janaina444@gmail.com-0.jpg', 'cover_image-janaina444@gmail.com-0.jpg', 'Esse é meu canal!');
INSERT INTO ChannelsUsers VALUES (3, 'Youtube Movies', '2015-09-02 11:01:10-08', 'youtubemovies@gmail.com', 'profile_picture-youtubemovies@gmail.com-0.jpg', 'cover_image-youtubemovies@gmail.com-0.jpg', 'All youtube movies in one place!');

CREATE TABLE Subscriptions
(id_channel INTEGER NOT NULL,
 id_subscriber INTEGER NOT NULL,
 notification_bell CHAR(1) NOT NULL CHECK((notification_bell = 'a') or (notification_bell = 'p') or (notification_bell = 'n')),
 PRIMARY KEY(id_channel, id_subscriber),
 FOREIGN KEY (id_channel) REFERENCES ChannelsUsers(id),
 FOREIGN KEY (id_subscriber) REFERENCES ChannelsUsers(id));

INSERT INTO Subscriptions VALUES (0,1,'a');
INSERT INTO Subscriptions VALUES (1,0,'n');
INSERT INTO Subscriptions VALUES (2,0,'p');
 
CREATE TABLE Memberships
(id SERIAL PRIMARY KEY,
 name VARCHAR(255) NOT NULL,	
 id_channel INTEGER NOT NULL,
 description VARCHAR(5000),	
 price_month FLOAT,
 FOREIGN KEY (id_channel) REFERENCES ChannelsUsers(id));
 
INSERT INTO Memberships VALUES (0,'Plano Básico Jao Gameplay',0,'Para quem quer ser membro em um preço acessível!',2.99);
INSERT INTO Memberships VALUES (1,'Plano Premium Jao Gameplay',0,'O plano mais completo, com acesso a todos os conteúdos!',5.99);
INSERT INTO Memberships VALUES (2,'Grupo de membros da Janaina',2,'Plano único do canal, acesso à conteúdo exclusivo!',4.0);

CREATE TABLE Badges
(level INTEGER NOT NULL,
 id_membership INTEGER NOT NULL,
 badge_icon_filename VARCHAR(300) NOT NULL UNIQUE,
 PRIMARY KEY(level, id_membership),
 FOREIGN KEY (id_membership) REFERENCES Memberships(id));
 
INSERT INTO Badges VALUES (0,0,'badge-membership0-level0.jpg');
INSERT INTO Badges VALUES (1,0,'badge-membership0-level1.jpg');
INSERT INTO Badges VALUES (2,0,'badge-membership2-level0.jpg');

CREATE TABLE Members
(id SERIAL PRIMARY KEY,
 id_membership INTEGER NOT NULL,
 id_member INTEGER NOT NULL,
 date_member_start TIMESTAMP NOT NULL,
 date_member_end TIMESTAMP,
 FOREIGN KEY (id_membership) REFERENCES Memberships(id),
 FOREIGN KEY (id_member) REFERENCES ChannelsUsers(id));
 
INSERT INTO Members VALUES (0,0,2,'2021-09-07 09:01:10-08','2021-11-07 09:01:10-08');
INSERT INTO Members VALUES (1,2,0,'2021-01-01 11:06:10-08','2021-02-01 11:06:10-08');
INSERT INTO Members VALUES (2,1,1,'2021-05-03 05:02:10-08');
 
CREATE TABLE Categories
(id SERIAL PRIMARY KEY,
 name VARCHAR(255) NOT NULL);
 
INSERT INTO Categories VALUES (0,'Jogos');
INSERT INTO Categories VALUES (1,'Aprender');
INSERT INTO Categories VALUES (2,'Esportes');
INSERT INTO Categories VALUES (3,'Filmes');

CREATE TABLE Contents
(id SERIAL PRIMARY KEY,
 creation_date_time TIMESTAMP NOT NULL,
 id_channel INTEGER NOT NULL,
 FOREIGN KEY (id_channel) REFERENCES ChannelsUsers(id));
 
INSERT INTO Contents VALUES (0,'2021-10-10 09:01:10-08',0);
INSERT INTO Contents VALUES (1,'2021-11-11 09:01:10-08',0);
INSERT INTO Contents VALUES (2,'2021-12-12 09:01:10-08',2);
INSERT INTO Contents VALUES (3,'2021-10-09 09:01:10-08',0);
INSERT INTO Contents VALUES (4,'2021-11-10 09:01:10-08',0);
INSERT INTO Contents VALUES (5,'2021-12-11 09:01:10-08',2);
INSERT INTO Contents VALUES (6,'2021-11-10 09:01:10-08',3);
INSERT INTO Contents VALUES (7,'2021-12-11 09:01:10-08',3);
INSERT INTO Contents VALUES (8,'2021-12-11 09:01:10-08',3);
INSERT INTO Contents VALUES (9,'2021-12-11 09:01:10-08',0);
 
CREATE TABLE Posts
(id INTEGER NOT NULL PRIMARY KEY,
 content VARCHAR(5000) NOT NULL,	
 image_filename VARCHAR(300) UNIQUE,
 FOREIGN KEY (id) REFERENCES Contents(id));
 
INSERT INTO Posts VALUES (0,'Pessoal venham conferir meu novo vídeo!','post_image0.jpg');
INSERT INTO Posts VALUES (1,'O vídeo da semana que vem vai ser especial. Spoiler na imagem.','post_image1.jpg');
INSERT INTO Posts VALUES (2,'Qual tipo de vídeos vocês gostariam de ver aqui no canal?');

CREATE TABLE Videos
(id INTEGER NOT NULL PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 filename VARCHAR(300) NOT NULL UNIQUE,
 max_quality INTEGER NOT NULL,
 duration INTEGER NOT NULL, 
 age_restriction INTEGER NOT NULL,
 short BOOLEAN NOT NULL, 
 live BOOLEAN NOT NULL, 
 visibility CHAR(3) NOT NULL CHECK((visibility = 'pvt') or (visibility = 'unl') or (visibility = 'pub')),
 description VARCHAR(5000),
 id_category INTEGER,
 thumbnail_filename VARCHAR(300) UNIQUE,
 FOREIGN KEY (id) REFERENCES Contents(id),
 FOREIGN KEY (id_category) REFERENCES Categories(id));
 
INSERT INTO Videos VALUES (3,'COD Warzone: Primeiro gameplay','video3.mp4',1080,414,14,FALSE,FALSE,'pub','Se inscrevam no canal!',0,'video_thumbnail3.jpg');
INSERT INTO Videos VALUES (4,'Jogando GTA Online','video4.mp4',1080,521,14,FALSE,FALSE,'pub','Se inscrevam no canal!',0,'video_thumbnail4.jpg');
INSERT INTO Videos VALUES (5,'Tutorial como gravar vídeo com celular','video5.mp4',720,211,0,FALSE,FALSE,'pub','Se inscrevam no canal!',1,'video_thumbnail5.jpg');
INSERT INTO Videos VALUES (6,'The Matrix Resurrections','video6.mp4',1080,8820,14,FALSE,FALSE,'pub','From visionary filmmaker Lana Wachowski comes “The Matrix Resurrections ,” the long-awaited fourth film in the groundbreaking franchise that redefined a genre.',3,'video_thumbnail6.jpg');
INSERT INTO Videos VALUES (7,'Venom: Let There Be Carnage','video7.mp4',1080,5820,14,FALSE,FALSE,'pub','Tom Hardy returns to the big screen as the lethal protector Venom, one of MARVELS greatest and most complex characters.',3,'video_thumbnail7.jpg');
INSERT INTO Videos VALUES (8,'Infinite','video8.mp4',1080,6360,0,FALSE,FALSE,'pub','For Evan McCauley (Mark Wahlberg), skills he has never learned and memories of places he has never visited haunt his daily life.',3,'video_thumbnail8.jpg');
INSERT INTO Videos VALUES (9,'Primeira Live do Canal','video9.mp4',1080,5223,0,FALSE,TRUE,'pub',NULL,0);

CREATE TABLE Movies
(id INTEGER NOT NULL PRIMARY KEY,
 genre VARCHAR(255) NOT NULL, 
 provider VARCHAR(255) NOT NULL, 
 price_buy FLOAT, 
 price_rent FLOAT, 
 FOREIGN KEY (id) REFERENCES Videos(id));

INSERT INTO Movies VALUES (6,'Action & adventure, Science fiction, Fantasy','Warner Bros. Entertainment',12);
INSERT INTO Movies VALUES (7,'Action & adventure, Drama, Thriller','Sony Pictures Movies & Shows',8,3);
INSERT INTO Movies VALUES (8,'Action & adventure, Fantasy, Science fiction, Thriller','paramount_brazil',6,2);

CREATE TABLE SubtitlesFilenames
(subtitle_filename VARCHAR(300) NOT NULL UNIQUE,
 display_name VARCHAR(255) NOT NULL,
 id_video INTEGER NOT NULL,
 PRIMARY KEY(display_name, id_video),
 FOREIGN KEY (id_video) REFERENCES Videos(id));

INSERT INTO SubtitlesFilenames VALUES ('subtitle_video6_ptbr.txt','Portuguese (Brazil)',6);
INSERT INTO SubtitlesFilenames VALUES ('subtitle_video6_sla.txt','Spanish (Latin America)',6);
INSERT INTO SubtitlesFilenames VALUES ('subtitle_video0_ptbr.txt','Portuguese (Brazil)',7);

CREATE TABLE AudiosFilenames
(audio_filename VARCHAR(300) NOT NULL UNIQUE,
 display_name VARCHAR(255) NOT NULL,
 id_video INTEGER NOT NULL,
 PRIMARY KEY(display_name, id_video),
 FOREIGN KEY (id_video) REFERENCES Videos(id));
 
INSERT INTO AudiosFilenames VALUES ('audio_video6_ptbr.mp3','Portuguese (Brazil)',6);
INSERT INTO AudiosFilenames VALUES ('audio_video6_sla.mp3','Spanish (Latin America)',6);
INSERT INTO AudiosFilenames VALUES ('audio_video7_ptbr.mp3','Portuguese (Brazil)',7);

CREATE TABLE Views
(id SERIAL NOT NULL PRIMARY KEY,
 id_video INTEGER NOT NULL,
 id_user INTEGER NOT NULL,
 date_time TIMESTAMP NOT NULL,
 stop_time INTEGER, 
 FOREIGN KEY (id_video) REFERENCES Videos(id),
 FOREIGN KEY (id_user) REFERENCES ChannelsUsers(id));

INSERT INTO Views VALUES (0,3,2,'2021-10-09 10:01:10-08',60);
INSERT INTO Views VALUES (1,3,1,'2021-10-09 11:01:10-08',55);
INSERT INTO Views VALUES (2,5,0,'2021-12-11 10:01:10-08',65);
INSERT INTO Views VALUES (3,9,0,'2021-12-11 09:01:10-08');
 
CREATE TABLE Ratings
(id_content INTEGER NOT NULL,
 id_user INTEGER NOT NULL,
 rating BOOLEAN NOT NULL,
 PRIMARY KEY(id_content, id_user),
 FOREIGN KEY (id_content) REFERENCES Contents(id),
 FOREIGN KEY (id_user) REFERENCES ChannelsUsers(id));
 
INSERT INTO Ratings VALUES (3,2,TRUE);
INSERT INTO Ratings VALUES (3,1,FALSE);
INSERT INTO Ratings VALUES (5,0,TRUE);
 
CREATE TABLE PriveledgedAccess
(id_content INTEGER NOT NULL,
 id_membership INTEGER NOT NULL,
 PRIMARY KEY(id_content, id_membership),
 FOREIGN KEY (id_content) REFERENCES Contents(id),
 FOREIGN KEY (id_membership) REFERENCES Memberships(id));
 
INSERT INTO PriveledgedAccess VALUES (0,0);
INSERT INTO PriveledgedAccess VALUES (1,1);
INSERT INTO PriveledgedAccess VALUES (2,2);
 
CREATE TABLE Playlists
(id SERIAL PRIMARY KEY,
 name VARCHAR(255) NOT NULL,
 private BOOLEAN NOT NULL, 
 id_channel INTEGER NOT NULL,
 FOREIGN KEY (id_channel) REFERENCES ChannelsUsers(id));
 
INSERT INTO Playlists VALUES (0,'Assistir mais tarde',TRUE,0); 
INSERT INTO Playlists VALUES (1,'Recomendo',FALSE,0); 
INSERT INTO Playlists VALUES (2,'Playlist 1',FALSE,2); 
 
CREATE TABLE PlaylistSaves
(id_playlist INTEGER NOT NULL,
 id_user INTEGER NOT NULL,
 PRIMARY KEY(id_playlist, id_user),
 FOREIGN KEY (id_playlist) REFERENCES Playlists(id),
 FOREIGN KEY (id_user) REFERENCES ChannelsUsers(id));

INSERT INTO PlaylistSaves VALUES (1,2); 
INSERT INTO PlaylistSaves VALUES (1,1); 
INSERT INTO PlaylistSaves VALUES (2,0); 

CREATE TABLE Listings
(id_playlist INTEGER NOT NULL,
 id_video INTEGER NOT NULL,
 video_order INTEGER NOT NULL,
 PRIMARY KEY(id_playlist, id_video),
 FOREIGN KEY (id_playlist) REFERENCES Playlists(id),
 FOREIGN KEY (id_video) REFERENCES Videos(id));

INSERT INTO Listings VALUES (1,3,1); 
INSERT INTO Listings VALUES (1,4,2); 
INSERT INTO Listings VALUES (2,5,3); 
 
CREATE TABLE Comments
(id SERIAL PRIMARY KEY,
 id_content INTEGER NOT NULL,
 id_user INTEGER NOT NULL,
 content VARCHAR(5000) NOT NULL,
 creation_date_time TIMESTAMP NOT NULL,
 FOREIGN KEY (id_content) REFERENCES Contents(id),
 FOREIGN KEY (id_user) REFERENCES ChannelsUsers(id));
 
INSERT INTO Comments VALUES (0,3,2,'FIRST','2021-10-09 10:03:10-08'); 
INSERT INTO Comments VALUES (1,3,1,'Que legal!','2021-10-09 11:03:10-08'); 
INSERT INTO Comments VALUES (2,5,0,'Gostei do vídeo!','2021-12-11 10:03:10-08'); 
INSERT INTO Comments VALUES (3,3,1,'Second','2021-10-09 11:03:10-08'); 
INSERT INTO Comments VALUES (4,3,0,'Valeu','2021-10-09 11:08:10-08'); 
INSERT INTO Comments VALUES (5,5,2,'Obrigada!','2021-12-11 10:03:10-08'); 
INSERT INTO Comments VALUES (6,5,2,'Obrigada!','2021-12-11 10:03:10-08'); 
INSERT INTO Comments VALUES (7,9,2,'Acompanhando a live!','2021-12-11 09:01:10-08'); 

CREATE TABLE StaticComments
(id INTEGER PRIMARY KEY,
 FOREIGN KEY (id) REFERENCES Comments(id));

INSERT INTO StaticComments VALUES (0);
INSERT INTO StaticComments VALUES (1);
INSERT INTO StaticComments VALUES (2);
INSERT INTO StaticComments VALUES (3);
INSERT INTO StaticComments VALUES (4);
INSERT INTO StaticComments VALUES (5);
 
CREATE TABLE CommentsJudgements
(id_static_comment INTEGER NOT NULL,
 id_user INTEGER NOT NULL,
 judgement BOOLEAN NOT NULL,
 PRIMARY KEY(id_static_comment, id_user),
 FOREIGN KEY (id_static_comment) REFERENCES StaticComments(id),
 FOREIGN KEY (id_user) REFERENCES ChannelsUsers(id));
 
INSERT INTO CommentsJudgements VALUES (0,0,TRUE);
INSERT INTO CommentsJudgements VALUES (1,0,TRUE);
INSERT INTO CommentsJudgements VALUES (2,2,TRUE);
 
CREATE TABLE CommentsOnContents
(id INTEGER PRIMARY KEY,
 pinned BOOLEAN NOT NULL,
 FOREIGN KEY (id) REFERENCES StaticComments(id));
 
INSERT INTO CommentsOnContents VALUES (0,FALSE);
INSERT INTO CommentsOnContents VALUES (1,TRUE);
INSERT INTO CommentsOnContents VALUES (2,FALSE);

CREATE TABLE CommentsOfComments
(id INTEGER PRIMARY KEY,
 id_comment_target INTEGER NOT NULL,
 FOREIGN KEY (id) REFERENCES StaticComments(id),
 FOREIGN KEY (id_comment_target) REFERENCES CommentsOnContents(id));
 
INSERT INTO CommentsOfComments VALUES (3,0);
INSERT INTO CommentsOfComments VALUES (4,1);
INSERT INTO CommentsOfComments VALUES (5,2);
 
-- Novas instâncias

INSERT INTO ChannelsUsers
VALUES (4, 'Receitas Logo Feitas', '2021-09-02 11:01:11-08', 'marcio321@gmail.com', 'profile_picture-marcio321@gmail.com-1.jpg', 'cover_image-ymarcio321@gmail.com-1.jpg', 'Receitas rápidas pelo menos uma vez por mês!');


INSERT INTO CONTENTS
VALUES (10,'2021-12-10 02:01:10-08',4);


INSERT INTO CONTENTS
VALUES (11,'2022-03-01 01:01:10-08',4);


INSERT INTO CONTENTS
VALUES (12,'2022-03-01 01:04:10-08',4);


INSERT INTO CONTENTS
VALUES (13,'2022-04-04 01:04:10-08',4);


INSERT INTO Ratings
VALUES (10,3,FALSE);


INSERT INTO Ratings
VALUES (11,3,FALSE);


INSERT INTO Ratings
VALUES (12,3,FALSE);


INSERT INTO Ratings
VALUES (13,3,TRUE);


INSERT INTO Videos
VALUES (10,'Chocolate com Feijão','video10.mp4',144,53,0,TRUE,FALSE,'pub',NULL,1,'video_thumbnail10.jpg');


INSERT INTO Videos
VALUES (11,'Copo de Azeite com Limão','video11.mp4',144,63,18,TRUE,FALSE,'pub',NULL,1,'video_thumbnail11.jpg');


INSERT INTO Videos
VALUES (12,'Drink de água com cerveja','video12.mp4',144,13,0,TRUE,FALSE,'pub',NULL,1,'video_thumbnail12.jpg');


INSERT INTO Posts
VALUES (13,'Cansei pessoal a producao dos shorts custou demais, obrigado pela presença!');


INSERT INTO Members
VALUES (3,1,4,'2022-01-01 11:06:10-08','2021-02-01 11:06:10-08');


INSERT INTO Members
VALUES (4,0,4,'2022-04-03 05:02:10-08');


INSERT INTO VIEWS
VALUES (4,6,0,'2021-12-11 10:01:10-08',2234);


INSERT INTO VIEWS
VALUES (5,7,0,'2021-12-11 09:01:10-08',4100);

INSERT INTO Contents VALUES (15,'2001-12-11 09:01:10-08',3);
INSERT INTO Videos VALUES (15,'Avengers','video14.mp4',1080,2000,12,FALSE,FALSE,'pub','superhero movie wow',3);
INSERT INTO Movies VALUES (15,'Action & adventure, Fantasy,','Disney',4,4);
INSERT INTO Subtitlesfilenames VALUES ('subtitle_video15_ptbr', 'Portuguese (Brazil)', 15);
INSERT INTO Audiosfilenames VALUES ('audio_video15_ptbr', 'Portuguese (Brazil)', 15);

INSERT INTO Views VALUES (6,15,4,'2021-12-11 10:01:10-08',3234);
INSERT INTO Views VALUES (7,6,4,'2021-12-11 09:01:10-08',3000);