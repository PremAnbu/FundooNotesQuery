CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY,
    UserFirstName NVARCHAR(50),
    UserLastName NVARCHAR(50),
    UserEmail NVARCHAR(50) unique,
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
    UserId int FOREIGN KEY REFERENCES Users(UserId),
	Email NVARCHAR(50)
);

CREATE TABLE Collaboration (
   CollaborationId INT IDENTITY(1, 1) PRIMARY KEY,
   UserId INT,
   UserNotesId INT,
   CollaboratorEmail NVARCHAR(50),
   CONSTRAINT FK_UserId FOREIGN KEY (UserId) REFERENCES Users (UserId),
   CONSTRAINT FK_NoteId FOREIGN KEY (UserNotesId) REFERENCES UserNotes (UserNotesId));

CREATE TABLE Labels (
    LabelId INT PRIMARY KEY IDENTITY,
    LabelName NVARCHAR(100));
----------------------------------------------
select * from Users;
select * from UserNotes;
select * from Collaboration;
select * from labels;

alter table UserNotes add Email NVARCHAR(50);

drop table Users;
drop table UserNotes;
drop table Collaboration;
drop table Labels;

---------------------------------------------------
Stored procedures

CREATE PROCEDURE spCreateUser
    @UserFirstName NVARCHAR(100),@UserLastName NVARCHAR(100),
    @UserEmail NVARCHAR(100),@UserPassword NVARCHAR(100)
AS
BEGIN
    INSERT INTO Users (UserFirstName, UserLastName, UserEmail, UserPassword)
    VALUES (@UserFirstName, @UserLastName, @UserEmail, @UserPassword);
END
CREATE PROCEDURE spGetUserByEmail
    @Email NVARCHAR(100)
AS
BEGIN
    SELECT * FROM Users WHERE UserEmail = @Email;
END
CREATE PROCEDURE spUpdatePassword
    @UserEmail NVARCHAR(100),
    @UserPassword NVARCHAR(2000)
AS
BEGIN
    UPDATE Users SET UserPassword = @UserPassword WHERE UserEmail = @UserEmail;
END
-----------------------------
CREATE PROCEDURE spCreateUserNotes
    @Title NVARCHAR(255),@Description NVARCHAR(MAX),@Colour NVARCHAR(50),
    @IsArchived BIT,@IsPinned BIT,@IsDeleted BIT,@UserId INT
AS
BEGIN
    INSERT INTO UserNotes (Title, Description, Colour, IsArchived, IsPinned, IsDeleted, UserId)
    VALUES (@Title, @Description, @Colour, @IsArchived, @IsPinned, @IsDeleted, @UserId);
END
CREATE PROCEDURE spDeleteNote
    @NoteId INT
AS
BEGIN
    UPDATE UserNotes SET IsDeleted = 1 WHERE UserNotesId = @NoteId;
END
CREATE PROCEDURE spGetAllNotesByUserId
    @UserId INT
AS
BEGIN
    SELECT * FROM UserNotes WHERE UserId = @UserId AND IsDeleted = 0;
END
CREATE PROCEDURE spGetAllNotesByEmail
    @Email NVARCHAR(100)
AS
BEGIN
    DECLARE @UserId INT;
    SELECT @UserId = UserId FROM Users WHERE UserEmail = @Email;
    IF (@UserId IS NOT NULL)
    BEGIN
        SELECT * FROM UserNotes WHERE UserId = @UserId AND IsDeleted = 0;
    END
    ELSE
    BEGIN
        SELECT NULL AS UserNotesId, NULL AS Title, NULL AS Description, NULL AS Colour, NULL AS IsArchived, NULL AS IsPinned, NULL AS IsDeleted, NULL AS UserId WHERE 1 = 0;
    END
END
CREATE PROCEDURE spGetUserIdByEmail
    @Email NVARCHAR(100)
AS
BEGIN
    SELECT UserId FROM Users WHERE UserEmail = @Email;
END
CREATE PROCEDURE spUpdateNote
    @UserId INT,@NoteId INT,@Description NVARCHAR(255),@Title NVARCHAR(100),@Colour NVARCHAR(50)
AS	
BEGIN
    UPDATE UserNotes SET Description = @Description,
        Title = @Title,Colour = @Colour WHERE UserId = @UserId AND UserNotesId = @NoteId;
END
----------------------------------------------









