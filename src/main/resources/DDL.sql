create table users(
	id int primary key auto_increment,
    userEmail varchar(45),
    userPassword varchar(16),
    isAdmin boolean
);

create table posts(
	id int primary key auto_increment,
    title varchar(80),
    body varchar(2000),
    createdAt datetime,
    userId int,
    foreign key (userId) references users(id)
);

create table comments(
	id int primary key auto_increment,
    body varchar(1000),
    createdAt datetime,
    approved boolean,
    userId int,
    postId int,
    foreign key (userId) references users(id),
    foreign key (postId) references posts(id)
    on delete cascade
);
