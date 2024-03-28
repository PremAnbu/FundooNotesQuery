CREATE TABLE Register (
    UserId INT PRIMARY KEY IDENTITY,
    UserFirstName NVARCHAR(50),
    UserLastName NVARCHAR(50),
    UserEmail NVARCHAR(50),
    UserPassword NVARCHAR(2000)
);

CREATE TABLE UserNotes (
    UserNotesId INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(MAX),
    Description NVARCHAR(MAX),
    Colour NVARCHAR(MAX),
    IsArchived bit DEFAULT (0),
    IsPinned BIT default(0),
    IsDeleted bit DEFAULT (0),
    UserId int FOREIGN KEY REFERENCES Register(UserId),
	Email NVARCHAR(50)
);

CREATE TABLE Collaboration (
   CollaborationId INT IDENTITY(1, 1) PRIMARY KEY,
   UserId INT,
   UserNotesId INT,
   CollaboratorEmail NVARCHAR(50),
   CONSTRAINT FK_UserId FOREIGN KEY (UserId) REFERENCES Register (UserId),
   CONSTRAINT FK_NoteId FOREIGN KEY (UserNotesId) REFERENCES UserNotes (UserNotesId));

CREATE TABLE Labels (
    LabelId INT PRIMARY KEY IDENTITY,
    LabelName NVARCHAR(100));
----------------------------------------------
select * from Register;
select * from UserNotes;
select * from Collaboration;
select * from labels;

alter table UserNotes add Email NVARCHAR(50);

drop table Register;
drop table UserNotes;
drop table Collaboration;
drop table Labels;

