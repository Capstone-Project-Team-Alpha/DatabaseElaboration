Use MOYO_DB

Go
DROP TABLE IF EXISTS Contact
DROP TABLE IF EXISTS Instructor_Role
DROP TABLE IF EXISTS Role
DROP TABLE IF EXISTS Areas_Of_Concern
DROP TABLE IF EXISTS IntakeForm
DROP TABLE IF EXISTS GoalsInterests
DROP TABLE IF EXISTS Goals
DROP TABLE IF EXISTS Interests
DROP TABLE IF EXISTS Appointment
DROP TABLE IF EXISTS Schedule
DROP TABLE IF EXISTS AppointmentName
DROP TABLE IF EXISTS CustomerLogIn
DROP TABLE IF EXISTS InstructorLogIn
DROP TABLE IF EXISTS Customers
DROP TABLE IF EXISTS Provinces
DROP TABLE IF EXISTS Instructor

create table Provinces
(
	ProvinceID int not null IDENTITY(1, 1)
		constraint PK_Provinces_ProvinceID primary key clustered,
	ProvinceName char(100) not null,
	Abbreviation char(2) not null
)

create table Customers
(
	CustomerID int not null IDENTITY(1, 1)
		constraint PK_Customers_CustomerID primary key clustered,
	Email varchar(350) not null,
	FirstName char(150) not null,
	LastName char(150) not null,
	Street char(250) not null,
	City char(200) not null,
	ProvinceID int not null
		constraint FK_Customer_ProvinceID references Provinces(ProvinceID),
	PostalCode char(10) null,
	DateOfBirth date not null, 
	Phone_Number char(10) not null
		constraint CK_Customers_PhoneNumber check (Phone_Number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Hobbies varchar(350) null,
	Occupation varchar(300) null
)

create table CustomerLogIn
(
	CustomerLoginID int not null IDENTITY(1, 1)
		constraint PK_CustomerLogIn_CustomerLoginID primary key clustered,
	CustomerID int not null
		constraint FK_CustomerLogIn_CustomerID references Customers(CustomerID),
	Email varchar(350) not null,
	Password varchar(250) not null,
	CreatedDate date not null
		constraint DF_CustomerLogIn_CreatedDate default getdate(),
	LastModifiedDate date not null
		constraint DF_CustomerLogIn_LastModifiedDate default getdate(),
	failedLoginAttempts int null
		constraint DF_CustomerLogIn_failedLoginAttempts default 0,
	status tinyint not null
		constraint DF_CustomerLogIn_Status default 1
		constraint CK_CustomerLogIn_Status check (status IN (1,0))
)

create table Contact
(
	ContactID int not null IDENTITY(1, 1)
		constraint PK_Contact_ContactID primary key clustered,
	CustomerID int not null
		constraint FK_Contact_CustomerID references Customers(CustomerID),
	FirstName char(150) not null,
	LastName char(150) not null,
	Phone_Number char(10) not null
		constraint CK_Contact_PhoneNumber check (Phone_Number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Email varchar(350) not null,
	Relationship char(150) not null
)

create table Instructor
(
	InstructorID int not null IDENTITY(1, 1)
		constraint PK_Instructor_InstructorID primary key clustered,
	Email varchar(350) not null,
	FirstName char(150) not null,
	LastName char(150) not null,
	Phone_Number char(10) not null
		constraint CK_Instructor_PhoneNumber check (Phone_Number like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	YearsOfExperience int not null
)

create table InstructorLogIn
(
	InstructorLoginID int not null IDENTITY(1, 1)
		constraint PK_InstructorLogIn_InstructorLoginID primary key clustered,
	InstructorID int not null
		constraint FK_InstructorLogIn_InstructorID references Instructor(InstructorID),
	Email varchar(350) not null,
	Password varchar(250) not null,
	CreatedDate date not null
		constraint DF_InstructorLogIn_CreatedDate default getdate(),
	LastModifiedDate date not null
		constraint DF_InstructorLogIn_LastModifiedDate default getdate(),
	failedLoginAttempts int null
		constraint DF_InstructorLogIn_failedLoginAttempts default 0,
	status tinyint not null
		constraint DF_InstructorLogIn_Status default 1
		constraint CK_InstructorLogIn_Status check (status IN (1,0))
)

create table Role
(
	RoleID int not null IDENTITY(1, 1)
		constraint PK_Role_RoleID primary key clustered,
	RoleName char(150) not null,
	Description char(255) not null,
	CreatedBy char(250) not null
)

create table Instructor_Role	
(
	InstructorRoleID int not null IDENTITY(1, 1)
		constraint PK_Instructor_Role_InstructorRoleID primary key clustered,
	InstructorID int not null
		constraint FK_Instructor_Role_InstructorID references Instructor(InstructorID),
	RoleID int not null
		constraint FK_Instructor_Role_RoleID references Role(RoleID)
)

create table AppointmentName
(
	AppointmentNameID int not null IDENTITY(1,1)
		constraint PK_AppointmentName_AppointmentNameID primary key clustered,
	AppointmentName char(350) not null
)

create table Schedule
(
	CalenderID int not null IDENTITY(1, 1)
		constraint PK_Schedule_CalenderID primary key clustered,
	InstructorID int not null
		constraint FK_Schedule_InstructorID references Instructor(InstructorID),
	AppointmentNameID int not null
		constraint FK_Schedule_AppointmentNameID references AppointmentName(AppointmentNameID),
	AppointmentDate date not null,
	AppointmentStartTime time not null,
	AppointmentEndTime time not null,
	DurationMins int not null,
	TotalNumberOfParticipants int not null
		constraint DF_Schedule_TotalNumberOfParticipants default 0,
	MaxParticipants int not null,
	Status tinyint not null
		constraint DF_Schedule_Status default 0
		constraint CK_Schedule_Status check (Status IN (1,0))
)

create table Appointment
(
	BookingID int not null IDENTITY(1, 1)
		constraint PK_Appointment_BookingID primary key clustered,
	CustomerID int null
		constraint FK_Appointment_CustomerID references Customers(CustomerID),
	CalenderID int not null
		constraint FK_Appointment_CalenderID references Schedule(CalenderID),
	FirstName char(150) not null,
	LastName char(150) not null,
	Email varchar(350) not null,	
	WaiverSigned tinyint not null
	constraint CK_Appointment_WaiverSigned check (WaiverSigned IN (1,0)),
	witness char(300) null,
	Status char(50) not null
		constraint DF_Appointment_Status default 'Pending'
)

create table Areas_Of_Concern
(
	ID int not null IDENTITY(1, 1)
		constraint PK_Areas_Of_Concern_ID primary key clustered,
	BookingID int not null
		constraint FK_Areas_Of_Concern_BookingID references Appointment(BookingID),
	Arms BIT not null
		constraint DF_Areas_Of_Concern_Arms default 0
		constraint CK_Areas_Of_Concern_Arms check (Arms IN (1,0)),
	Chest BIT not null
		constraint DF_Areas_Of_Concern_Chest default 0
		constraint CK_Areas_Of_Concern_Chest check (Chest IN (1,0)),
	Feet BIT not null
		constraint DF_Areas_Of_Concern_Feet default 0
		constraint CK_Areas_Of_Concern_Feet check (Feet IN (1,0)),
	Head BIT not null
		constraint DF_Areas_Of_Concern_Head default 0
		constraint CK_Areas_Of_Concern_Head check (Head IN (1,0)),
	Hip BIT not null
		constraint DF_Areas_Of_Concern_Hip default 0
		constraint CK_Areas_Of_Concern_Hip check (Hip IN (1,0)),
	Knees BIT not null
		constraint DF_Areas_Of_Concern_Knees default 0
		constraint CK_Areas_Of_Concern_Knees check (Knees IN (1,0)),
	Legs BIT not null
		constraint DF_Areas_Of_Concern_Legs default 0
		constraint CK_Areas_Of_Concern_Legs check (Legs IN (1,0)),
	Neck BIT not null
		constraint DF_Areas_Of_Concern_Neck default 0
		constraint CK_Areas_Of_Concern_Neck check (Neck IN (1,0))
)

create table IntakeForm
(
	IntakeFormID int not null IDENTITY(1, 1)
		constraint PK_IntakeForm_FormID primary key clustered,
	BookingID int not null
		constraint FK_IntakeForm_BookingID references Appointment(BookingID),
	Injuries char(350) null,   
	HealthConcerns char(350) not null,
	Goals TEXT not null,
	YogaInterests TEXT null,
	RatePhysicalActivity int not null, 
	RateStress int not null,   
	Comfortable_Self_Assessment int not null, 
	Practice_Self_Assessment int not null,  
	Health_conditions_Recently_Past TEXT null,
	Concerns_Hopes_Goals_Anticipations TEXT null
)

create table Interests	
(
	InterestsID int IDENTITY(1,1) not null
		constraint PK_Interests_InterestsID primary key clustered,
	InterestDesc varchar(250) not null,
	CreatedDate date not null
		constraint DF_Interest_CreatedDate default getdate(),
	LastModifiedDate date not null
		constraint DF_Interest_LastModifiedDate default getdate()
)

create table Goals	
(
	GoalsID int not null IDENTITY(1, 1)
		constraint PK_Goals_GoalID primary key clustered,
	GoalDescription varchar(250) not null,
	CreatedDate Date not null
		constraint DF_Goals_CreatedDate default getdate(),
	LastModifiedDate date NOT NULL
		constraint DF_Goals_LastModifiedDate default getdate()
)

create table GoalsInterests
(
	GoalInterestsID int not null IDENTITY(1, 1)
		constraint PK_GoalsInterests_GoalsInterestsID primary key clustered,
	GoalsID int not null
		constraint FK_GoalsInterests_GoalsID references Goals(GoalsID),
	InterestsID int not null
		constraint FK_GoalsInterests_InterestsID references Interests(InterestsID),
	BookingID int not null
		constraint FK_GoalsInterests_BookingID references Appointment(BookingID)
)

go

INSERT INTO Provinces (ProvinceName, Abbreviation)
VALUES('Alberta', 'AB'),
	  ('British Columbia', 'BC'),
      ('Manitoba', 'MB'),
      ('New Brunswick', 'NB'),
      ('Newfoundland and Labrador', 'NL'),
      ('Northwest Territories', 'NT'),
      ('Nova Scotia', 'NS'),
      ('Nunavut', 'NU'),
      ('Ontario', 'ON'),
      ('Prince Edward Island', 'PE'),
      ('Quebec', 'QC'),
      ('Saskatchewan', 'SK'),
      ('Yukon', 'YT');