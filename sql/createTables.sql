DROP TABLE IF EXISTS Donations;
DROP TABLE IF EXISTS Volunteers;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Administrators;
DROP TABLE IF EXISTS Members;



CREATE TABLE Members (
	MemberID		INT IDENTITY(1, 1),
    NewMemberID AS 'M' + RIGHT('000' + CAST(MemberID AS VARCHAR(3)), 3) PERSISTED,
	MemberEmail		VARCHAR(255)	NOT NULL UNIQUE, 
	FirstName		VARCHAR(50)		NOT NULL,
	LastName		VARCHAR(50)		NOT NULL,
	MemberPassword	CHAR(12)		NOT NULL UNIQUE,
	Birthday		DATE			NOT NULL,
	PhoneNumber		VARCHAR(20)		NOT NULL UNIQUE,
	CONSTRAINT PK_Members PRIMARY KEY (NewMemberID)
);


CREATE TABLE Administrators (
	AdminID			CHAR(4)			CHECK (AdminID LIKE 'A%'),
	AdminEmail		VARCHAR(255)	NOT NULL UNIQUE,
	AdminPassword	CHAR(12)		NOT NULL UNIQUE,
	CONSTRAINT PK_Administrators PRIMARY KEY (AdminID)
);


CREATE TABLE Events (
	EventID		INT IDENTITY(1, 1),
    EventType	VARCHAR(50)			NOT NULL,
	EventDate	DATE				NOT NULL,
	EventTime	DATETIME			NOT NULL,
    NewEventID	AS ( 
        CASE 
            WHEN EventType = 'Healthcare' THEN 'H' + RIGHT('000' + CAST(EventID AS VARCHAR(3)), 3)
            WHEN EventType = 'CSR' THEN 'C' + RIGHT('000' + CAST(EventID AS VARCHAR(3)), 3)
            WHEN EventType = 'Environment' THEN 'E' + RIGHT('000' + CAST(EventID AS VARCHAR(3)), 3)
            WHEN EventType = 'Education' THEN 'ED' + RIGHT('000' + CAST(EventID AS VARCHAR(3)), 3)
        END )
		PERSISTED,
	AdminID		CHAR(4),
	CONSTRAINT PK_Events PRIMARY KEY (NewEventID, EventType, EventDate, EventTime),
	CONSTRAINT FK_Events_AdminID FOREIGN KEY (AdminID) REFERENCES Administrators(AdminID)
);


CREATE TABLE Posts (
	PostID		INT IDENTITY(1, 1),
    NewPostID AS 'P' + RIGHT('000' + CAST(PostID AS VARCHAR(3)), 3) PERSISTED,
	Title		VARCHAR(255)	NOT NULL,
	Content		TEXT			NOT NULL,
	PictureURL	VARCHAR(255)	NOT NULL,
	PostedOn	DATETIME DEFAULT GETDATE(),
	AdminID		CHAR(4),
	NewEventID	VARCHAR(4),
	EventType	VARCHAR(50),
	EventDate   DATE,
	EventTime	DATETIME,
	CONSTRAINT PK_Posts PRIMARY KEY (PostID),
	CONSTRAINT FK_Posts_AdminID FOREIGN KEY (AdminID) REFERENCES Administrators(AdminID),
	CONSTRAINT FK_Posts_Event FOREIGN KEY (NewEventID, EventType, EventDate, EventTime) REFERENCES Events(NewEventID, EventType, EventDate, EventTime)
);


CREATE TABLE Volunteers (
	VolunteerID INT IDENTITY(1,1),
	NewVolunteerID AS 'V' + RIGHT('000' + CAST(VolunteerID AS VARCHAR(3)), 3) PERSISTED,
	NewEventID		VARCHAR(4),
	EventType		VARCHAR(50),
	EventDate		DATE,
	EventTime		DATETIME,
	NewMemberID		VARCHAR(4),
	CONSTRAINT PK_Volunteers PRIMARY KEY (NewVolunteerID),
	CONSTRAINT FK_Volunteers_Event FOREIGN KEY (NewEventID, EventType, EventDate, EventTime) REFERENCES Events(NewEventID, EventType, EventDate, EventTime),
	CONSTRAINT FK_Volunteers_MemberID FOREIGN KEY (NewMemberID) REFERENCES Members(NewMemberID)
);


CREATE TABLE Donations ( 
    DonationID		INT IDENTITY(1, 1),
    NewDonationID AS 'D' + RIGHT('000' + CAST(DonationID AS VARCHAR(3)), 3) PERSISTED,  
    DonationAmount	INT,
    DonationDate	DATE, 
	NewEventID		VARCHAR(4),
	EventType		VARCHAR(50),
	EventDate		DATE,
	EventTime		DATETIME,
	NewMemberID		VARCHAR(4),
    CONSTRAINT PK_Donations PRIMARY KEY (DonationID), 
	CONSTRAINT FK_Donations_Event FOREIGN KEY (NewEventID, EventType, EventDate, EventTime) REFERENCES Events(NewEventID, EventType, EventDate, EventTime),
	CONSTRAINT FK_Donations_MemberID FOREIGN KEY (NewMemberID) REFERENCES Members(NewMemberID)
); 

/*
INSERT INTO Members (MemberEmail, FirstName, LastName, MemberPassword, Birthday, PhoneNumber) VALUES
    ('john123@email.com', 'John', 'Wong', 'johnwong123@', '12/03/2001', '98765432'),
    ('brucelee@email.com', 'Bruce', 'Lee', 'bruceee@1234', '04/01/1998', '87654321');

INSERT INTO Administrators (AdminID, AdminEmail, AdminPassword) VALUES
	('A001', 'S12345678@connect.np.edu.sg', 'S12345678@!8');

INSERT INTO Events (EventID, EventType, EventDate, EventTime) VALUES
	();

INSERT INTO Posts (PostID, Title, Content, PictureURL, PostedOn) VALUES
	();

INSERT INTO Volunteers (VolunteerID) VALUES
	();

INSERT INTO Donations (DonationID) VALUES
	();
*/