--Create Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    gender VARCHAR(10),
    age INT,
    city VARCHAR(50),
    registration_date DATE
);

-- Create Doctors Table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100),
    specialization VARCHAR(100),
    department VARCHAR(100)
);

-- Create Appointments Table
CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    consultation_fee DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Create Admissions Table
CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT,
    admission_date DATE,
    discharge_date DATE,
    diagnosis VARCHAR(100),
    treatment_cost DECIMAL(12,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Insert Sample Patients
INSERT INTO patients VALUES
(1,'Rahul Sharma','Male',34,'Mumbai','2024-01-05'),
(2,'Priya Verma','Female',29,'Delhi','2024-01-10'),
(3,'Amit Patel','Male',42,'Pune','2024-02-15'),
(4,'Sneha Joshi','Female',37,'Bangalore','2024-03-01'),
(5,'Rohan Gupta','Male',51,'Hyderabad','2024-03-20');

-- Insert Sample Doctors
INSERT INTO doctors VALUES
(101,'Dr. Mehta','Cardiology','Heart Care'),
(102,'Dr. Singh','Orthopedics','Bone Care'),
(103,'Dr. Rao','Neurology','Neuro Care'),
(104,'Dr. Shah','General Medicine','General');

-- Insert Sample Appointments
INSERT INTO appointments VALUES
(1001,1,101,'2025-01-05','Completed',800),
(1002,2,104,'2025-01-06','Completed',500),
(1003,3,102,'2025-01-08','Cancelled',700),
(1004,4,103,'2025-01-09','Completed',1000),
(1005,5,101,'2025-01-12','Completed',800);

-- Insert Sample Admissions
INSERT INTO admissions VALUES
(201,1,'2025-01-05','2025-01-10','Heart Surgery',250000),
(202,2,'2025-01-08','2025-01-11','Fever',12000),
(203,3,'2025-01-15','2025-01-22','Fracture',85000),
(204,5,'2025-01-18','2025-01-21','Cardiac Checkup',45000);

---Business KPIs
--1.Total Patients
SELECT 
	COUNT(DISTINCT patient_id) AS total_customers
FROM patients

--2.Total Admissions
SELECT 
	COUNT(DISTINCT admission_id) AS total_admissions
FROM admissions

--3.Total Appointments
SELECT 
	COUNT(DISTINCT appointment_id) AS total_appointments
FROM appointments

--4.Appointment completion Rate
SELECT 
	ROUND(
		COUNT(CASE WHEN status ='Completed' THEN 1 END) * 100 /
		COUNT(*),
		2	
	) AS completion_rate
FROM appointments

--5.Appointment cancellation Rate
SELECT 
	ROUND(
		COUNT(CASE WHEN status ='Cancelled' THEN 1 END) * 100 /
		COUNT(*),
		2	
	) AS completion_rate
FROM appointments


--6.Doctor-wise Patient Count
SELECT 
	d.doctor_name,
	COUNT(a.patient_id) AS patient_count
FROM doctors d
LEFT JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_name;

--7.Department-wise Revenue
SELECT
	d.department,
	SUM(a.consultation_fee) AS revenue
FROM doctors d
JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.department;

--8.Average consultation fee
SELECT
	AVG(consultation_fee) AS average_fee
FROM appointments;

--9.Average treatment fee
SELECT
	AVG(treatment_cost) AS average_treatment_cost
FROM admissions;

--10.Average length of stay
SELECT
	AVG(discharge_date - admission_date) AS average_staydays
FROM admissions

--11.Daily Patient Admissions
SELECT
	admission_date,
	COUNT(*) AS admissions
FROM admissions
GROUP BY admission_date
ORDER BY admission_date

--12.Monthly admission Trend
SELECT
	EXTRACT 
	(MONTH from admission_date) AS month,
	COUNT(*) AS admissions
FROM admissions
GROUP BY month
ORDER BY month

--13.Readmission Rate
WITH patient_admissions AS (
    SELECT
        patient_id,
        COUNT(*) AS admission_count
    FROM admissions
    GROUP BY patient_id
)
SELECT
    ROUND(
        COUNT(CASE WHEN admission_count > 1 THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS readmission_rate
FROM patient_admissions;

--14.Bed Occupacy Rate
SELECT
	ROUND(
		SUM(discharge_date - admission_date)::numeric
		/ (20* 31) * 100,
		2
		) AS occupacy_rate
FROM admissions

--15.Top doctors by Patient volume
SELECT
	d.doctor_name,
	COUNT(DISTINCT a.patient_id) AS patient_count
FROM doctors d
LEFT JOIN appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_name
ORDER BY patient_count DESC

--16.Revenue by department
SELECT
	d.department,
	SUM(a.consultation_fee) AS revenue
FROM doctors d
JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.department
ORDER BY revenue DESC;

--17.Revenue by doctor
SELECT
	d.doctor_name,
	SUM(a.consultation_fee) AS revenue
FROM doctors d
JOIN appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_name
ORDER BY revenue DESC;

--18.Most common diagnosis
SELECT
	diagnosis,
	COUNT(*) AS frequency
FROM admissions
GROUP BY diagnosis
ORDER BY frequency DESC;

--19.Patient distribution by city
SELECT
	city,
	COUNT(*) AS patients
FROM patients
GROUP BY city
ORDER BY patients DESC

--20.Average Patient Age
SELECT 
	AVG(age) as avg_age
FROM patients
	

