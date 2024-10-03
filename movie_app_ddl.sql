DROP SCHEMA IF EXISTS mv_bkg_usr CASCADE;
DROP SCHEMA IF EXISTS mv_bkg_movie CASCADE;
DROP SCHEMA IF EXISTS mv_bkg_showtime CASCADE;
DROP SCHEMA IF EXISTS mv_bkg_booking CASCADE;
DROP SCHEMA IF EXISTS mv_bkg_paymt CASCADE;
DROP SCHEMA IF EXISTS mv_bkg_notification CASCADE;

CREATE SCHEMA mv_bkg_usr;
CREATE SCHEMA mv_bkg_movie;
CREATE SCHEMA mv_bkg_showtime;
CREATE SCHEMA mv_bkg_booking;
CREATE SCHEMA mv_bkg_paymt;
CREATE SCHEMA mv_bkg_notification;

DROP TABLE IF EXISTS mv_bkg_usr.T_User;
DROP TABLE IF EXISTS mv_bkg_usr.T_User_Pref;
DROP TABLE IF EXISTS mv_bkg_usr.T_Card_Details;

DROP TABLE IF EXISTS mv_bkg_movie.T_Movie;
DROP TABLE IF EXISTS mv_bkg_movie.T_Movie_Review;

DROP TABLE IF EXISTS mv_bkg_showtime.T_Theater;
DROP TABLE IF EXISTS mv_bkg_showtime.T_Screen;
DROP TABLE IF EXISTS mv_bkg_showtime.T_Showtime;

DROP TABLE IF EXISTS mv_bkg_booking.T_Bkg;
DROP TABLE IF EXISTS mv_bkg_booking.T_Bkg_Details;

DROP TABLE IF EXISTS mv_bkg_paymt.T_Paymt;

DROP TABLE IF EXISTS mv_bkg_notification.T_Notification;

CREATE TABLE mv_bkg_usr.T_User (
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Usr_Nm VARCHAR(20) NOT NULL,
	A_Email VARCHAR(255) NOT NULL,
	A_Pswd VARCHAR(100) NOT NULL,
	A_Fst_Nm VARCHAR(255) NOT NULL,
	A_Last_Nm VARCHAR(255) NULL,
	A_Phn VARCHAR(20) NOT NULL,
	A_Role VARCHAR(8) NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKUsr PRIMARY KEY (A_Usr_Id),
	CONSTRAINT UKUsrNm UNIQUE (A_Usr_Nm),
	CONSTRAINT UKUsrEm UNIQUE (A_Email),
	CONSTRAINT UKUsrPhn UNIQUE (A_Phn)
);

CREATE INDEX IDX_User_UserId ON mv_bkg_usr.T_User
(
	A_Usr_Id
);

CREATE INDEX IDX_User_UserName ON mv_bkg_usr.T_User
(
	A_Usr_Nm
);

CREATE INDEX IDX_User_Email ON mv_bkg_usr.T_User
(
	A_Email
);

CREATE TABLE mv_bkg_usr.T_User_Pref (
	A_Usr_Pref_Id VARCHAR(37) NOT NULL,
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Genre VARCHAR(255) NULL,
	A_Lang VARCHAR(255) NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKUsrPref PRIMARY KEY (A_Usr_Pref_Id),
	CONSTRAINT FKUsrPref FOREIGN KEY (A_Usr_Id) REFERENCES mv_bkg_usr.T_User(A_Usr_Id)
);

CREATE TABLE mv_bkg_usr.T_Card_Details (
	A_Card_Details_Id VARCHAR(37) NOT NULL,
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Crd_No VARCHAR(255) NOT NULL,
	A_Crd_Type VARCHAR(50) NOT NULL,
	A_Exp_Dt DATE NOT NULL,
	A_Bill_Addrs VARCHAR(255) NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKCardDetails PRIMARY KEY (A_Card_Details_Id),
	CONSTRAINT FKCardDetails FOREIGN KEY (A_Usr_Id) REFERENCES mv_bkg_usr.T_User(A_Usr_Id)
);

CREATE INDEX IDX_CardDetails_User_Id ON mv_bkg_usr.T_Card_Details
(
	A_Usr_Id
);

CREATE TABLE mv_bkg_movie.T_Movie (
	A_Movie_Id VARCHAR(37) NOT NULL,
	A_Title VARCHAR(255) NOT NULL,
	A_Desc VARCHAR(255) NULL,
	A_Director VARCHAR(50) NULL,
	A_Producer VARCHAR(50) NULL,
	A_Release_Dt DATE NULL,
	A_Lang VARCHAR(50) NULL,
	A_Duratn INTEGER NULL,
	A_Ratng NUMERIC(3, 1),
	A_Genre VARCHAR(255) NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKMovie PRIMARY KEY (A_Movie_Id)
);

CREATE INDEX IDX_Movie_Titile ON mv_bkg_movie.T_Movie
(
	A_Title
);

CREATE INDEX IDX_Movie_Genre ON mv_bkg_movie.T_Movie
(
	A_Genre
);

CREATE TABLE mv_bkg_movie.T_Movie_Review (
	A_Review_Id VARCHAR(37) NOT NULL,
	A_Movie_Id VARCHAR(37) NOT NULL,
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Ratng NUMERIC(3, 1) NOT NULL,
	A_Review VARCHAR(255) NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKMvReview PRIMARY KEY (A_Review_Id),
	CONSTRAINT FKReviewUsr FOREIGN KEY (A_Usr_Id) REFERENCES mv_bkg_usr.T_User(A_Usr_Id),
	CONSTRAINT FKReviewMovie FOREIGN KEY (A_Movie_Id) REFERENCES mv_bkg_movie.T_Movie(A_Movie_Id)
);

CREATE INDEX IDX_Movie_Details_Movie_User ON mv_bkg_movie.T_Movie_Review
(
	A_Movie_Id, A_Usr_Id
);

CREATE INDEX IDX_Movie_Details_Movie_Id ON mv_bkg_movie.T_Movie_Review
(
	A_Movie_Id
);

CREATE TABLE mv_bkg_showtime.T_Theater (
	A_Theater_Id VARCHAR(37) NOT NULL,
	A_Nm VARCHAR(255) NOT NULL,
	A_Locatn VARCHAR(150) NULL,
	A_Gpos_Lat NUMERIC(10, 7) NOT NULL,
	A_Gos_Long NUMERIC(10, 7) NOT NULL,
	A_Tot_Scrns INTEGER NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKTheater PRIMARY KEY (A_Theater_Id)
);

CREATE TABLE mv_bkg_showtime.T_Screen (
	A_Screen_Id VARCHAR(37) NOT NULL,
	A_Theater_Id VARCHAR(37) NOT NULL,
	A_Scrn_No INTEGER NULL,
	A_Tot_Seats INTEGER NULL,
	A_Cr_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKScreen PRIMARY KEY (A_Screen_Id),
	CONSTRAINT FKScreen FOREIGN KEY (A_Theater_Id) REFERENCES mv_bkg_showtime.T_Theater(A_Theater_Id)
);

CREATE INDEX IDX_Screen_Theater ON mv_bkg_showtime.T_Screen
(
	A_Theater_Id
);

CREATE TABLE mv_bkg_showtime.T_Showtime (
	A_Showtime_Id VARCHAR(37) NOT NULL,
	A_Movie_Id VARCHAR(37) NOT NULL,
	A_Screen_Id VARCHAR(37) NOT NULL,
	A_Scrn_No INTEGER NOT NULL,
	A_Strt_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	A_End_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	A_Avl_Seats INTEGER NOT NULL,
	CONSTRAINT PKShowtime PRIMARY KEY (A_Showtime_Id),
	CONSTRAINT FKShowtimeMov FOREIGN KEY (A_Movie_Id) REFERENCES mv_bkg_movie.T_Movie(A_Movie_Id),
	CONSTRAINT FKShowtimeScrn FOREIGN KEY (A_Screen_Id) REFERENCES mv_bkg_showtime.T_Screen(A_Screen_Id)
);

CREATE INDEX IDX_Showtime_Movie_Start ON mv_bkg_showtime.T_Showtime
(
	A_Movie_Id, A_Strt_Dtm
);

CREATE INDEX IDX_Showtime_Sceen ON mv_bkg_showtime.T_Showtime
(
	A_Screen_Id
);

CREATE TABLE mv_bkg_booking.T_Bkg (
	A_Bkg_Id VARCHAR(37) NOT NULL,
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Showtime_Id VARCHAR(37) NOT NULL,
	A_Bkg_No VARCHAR(10) NOT NULL,
	A_Show_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	A_No_Tckts INTEGER NOT NULL,
	A_Tot_Amt NUMERIC(10, 2) NOT NULL,
	A_St VARCHAR(10) NOT NULL,
	A_Cr_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	A_Upd_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKBkg PRIMARY KEY (A_Bkg_Id),
	CONSTRAINT FKBkgUsr FOREIGN KEY (A_Usr_Id) REFERENCES mv_bkg_usr.T_User(A_Usr_Id),
	CONSTRAINT FKBkgShowtime FOREIGN KEY (A_Showtime_Id) REFERENCES mv_bkg_showtime.T_Showtime(A_Showtime_Id)
);


CREATE INDEX IDX_Bkg_Usr_Bkgtm ON mv_bkg_booking.T_Bkg
(
	A_Usr_Id, A_Show_Dtm
);

CREATE INDEX IDX_Bkg_Showtime ON mv_bkg_booking.T_Bkg
(
	A_Showtime_Id
);

CREATE INDEX IDX_Bkg ON mv_bkg_booking.T_Bkg
(
	A_Upd_Dtm ASC
);

CREATE TABLE mv_bkg_booking.T_Bkg_Details (
	A_Bkg_Details_Id VARCHAR(37) NOT NULL,
	A_Bkg_Id VARCHAR(37) NOT NULL,
	A_Seat_No VARCHAR(10) NOT NULL,
	A_Tckt_Price NUMERIC(10, 2) NOT NULL,
	A_Show_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKBkgDetails PRIMARY KEY (A_Bkg_Details_Id),
	CONSTRAINT FKBkgDetails FOREIGN KEY (A_Bkg_Id) REFERENCES mv_bkg_booking.T_Bkg(A_Bkg_Id)
);

CREATE INDEX IDX_Bkg_Details ON mv_bkg_booking.T_Bkg_Details
(
	A_Bkg_Id
);

CREATE TABLE mv_bkg_paymt.T_Paymt (
	A_Paymt_Id VARCHAR(37) NOT NULL,
	A_Bkg_Id VARCHAR(37) NOT NULL,
	A_Amt DECIMAL(10, 2) NOT NULL,
	A_St VARCHAR(10) NOT NULL,
	A_Paymt_Mthod VARCHAR(10) NOT NULL,
	A_Card_Details_Id VARCHAR(37) NULL,
	A_Show_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	A_Trnsctn_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKPaymt PRIMARY KEY (A_Paymt_Id),
	CONSTRAINT FKPaymtBkg FOREIGN KEY (A_Bkg_Id) REFERENCES mv_bkg_booking.T_Bkg(A_Bkg_Id),
	CONSTRAINT FKCardDetails FOREIGN KEY (A_Card_Details_Id) REFERENCES mv_bkg_usr.T_Card_Details(A_Card_Details_Id)
);

CREATE INDEX IDX_Paymt ON mv_bkg_paymt.T_Paymt
(
	A_Paymt_Id, A_Trnsctn_Dtm ASC
);

CREATE TABLE mv_bkg_notification.T_Notification (
	A_Notification_Id VARCHAR(37) NOT NULL,
	A_Usr_Id VARCHAR(37) NOT NULL,
	A_Type VARCHAR(50) NOT NULL,
	A_Msg VARCHAR(300) NOT NULL,
	A_Sent_Dtm TIMESTAMP NOT NULL DEFAULT timezone('UTC', now()),
	CONSTRAINT PKNotftn PRIMARY KEY (A_Notification_Id),
	CONSTRAINT FKNotftn FOREIGN KEY (A_Usr_Id) REFERENCES mv_bkg_usr.T_User(A_Usr_Id)
);

CREATE INDEX IDX_Notification ON mv_bkg_notification.T_Notification
(
	A_Usr_Id
);