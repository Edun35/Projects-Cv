-- Keep a log of any SQL queries you execute as you solve the mystery.
.schema

--1
SELECT description FROM crime_scene_reports
WHERE (day = 28) AND (month = 7) AND (year = 2020) AND (street = "Chamberlin Street");

--2
SELECT name, transcript FROM interviews
WHERE (day = 28) AND (month = 7) AND (year = 2020) AND (transcript LIKE "%courthouse%");

--3
SELECT name FROM people
WHERE id IN (
	SELECT person_id FROM bank_accounts
	WHERE account_number IN
	(
		SELECT account_number FROM atm_transactions
		WHERE day = 28 AND month = 7 AND year = 2020 AND atm_location = 'Fifer Street' AND transaction_type = 'withdraw'
	)
)
AND (license_plate IN
(
	SELECT license_plate FROM courthouse_security_logs
	WHERE day = 28 AND month = 7 AND year = 2020 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = 'exit'
)
)
AND (phone_number IN
(
	SELECT caller FROM phone_calls
	WHERE day = 28 AND month = 7 AND year = 2020 AND duration < 60
)
)
AND (passport_number IN
(
	SELECT passport_number FROM passengers
	WHERE flight_id IN
	(
		SELECT id FROM flights
		WHERE day = 29 AND month = 7 AND year = 2020 AND (origin_airport_id IN (SELECT id FROM airports WHERE city = 'Fiftyville'))
		ORDER BY  hour, minute
		LIMIT 1
	)
)
);

--4
SELECT name FROM people 
WHERE phone_number IN
(
	SELECT receiver FROM phone_calls
	WHERE day = 28 
	AND month = 7 
	AND year = 2020 
	AND duration < 60 
	AND (caller IN 
	(
		SELECT phone_number FROM people
		WHERE name IN (SELECT name FROM people
WHERE id IN ( 	
	SELECT person_id FROM bank_accounts
	WHERE account_number IN 
	(
		SELECT account_number FROM atm_transactions
		WHERE day = 28 AND month = 7 AND year = 2020 AND atm_location = 'Fifer Street' AND transaction_type = 'withdraw' 
	)
)  
AND (license_plate IN
(
	SELECT license_plate FROM courthouse_security_logs
	WHERE day = 28 AND month = 7 AND year = 2020 AND hour = 10 AND minute BETWEEN 15 AND 25 AND activity = 'exit'
)
)
AND (phone_number IN
(
	SELECT caller FROM phone_calls
	WHERE day = 28 AND month = 7 AND year = 2020 AND duration < 60
)
)
AND (passport_number IN
(
	SELECT passport_number FROM passengers 
	WHERE flight_id IN
	(
		SELECT id FROM flights
		WHERE day = 29 AND month = 7 AND year = 2020 AND (origin_airport_id IN (SELECT id FROM airports WHERE city = 'Fiftyville'))
		ORDER BY  hour, minute 
		LIMIT 1
	)
)
)
	) 
	)
)
);
--5
SELECT city FROM airports  
WHERE id IN 
(
	SELECT destination_airport_id FROM flights
	WHERE day = 29 AND month = 7 AND year = 2020 AND (origin_airport_id IN (SELECT id FROM airports WHERE city = 'Fiftyville'))
	ORDER BY  hour, minute 
	LIMIT 1
);

--1
--find crime in crime scene report - read description
--Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
--Interviews were conducted today with three witnesses who were present at the time
-- — each of their interview transcripts mentions the courthouse.

--2
--find witness interviews
--Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time frame.
--Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
--Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.

--3
--atm on fifer street withdraw
--and plate courthouse_security_log
--match car plate with owner name and who used atm on fifer street
--and who was caller on <60 phone call
--and who left city on earliest flight on next day.
--Ernest

--4
--find accomplice - reciever of earlier phone call as theif now known use theif phone num as caller
--BERTHOLD

--5
--find location - location of earliest flight day after robbery accomplice bought tickets
--London