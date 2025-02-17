
--- 1- crear base de datos y tablas ---
 create database DBCRUD

 go

 use DBCRUD

 go


create table Departamento(
IdDepartamento int primary key identity,
Nombre varchar(50)
)

go

 create table Empleado(
 IdEmpleado int primary key identity,
 NombreCompleto varchar(50),
 IdDepartamento int references Departamento(IdDepartamento),
 Sueldo decimal(10,2),
 FechaContrato date
 )

 go

 insert Departamento(Nombre) values
 ('Administracion'),
 ('Marketing'),
 ('Ventas'),
 ('Comercio')

 insert into Empleado(NombreCompleto,IdDepartamento,Sueldo,FechaContrato)
 values('Roxane',2,2500,GETDATE())



--- 2- crear procedimiento almacenados ---

create function fn_departamentos()
returns table
as
return
	select IdDepartamento,Nombre from Departamento

go

create function fn_empleados()
returns table
as
return
(
	select e.IdEmpleado,e.NombreCompleto,
	d.IdDepartamento,d.Nombre,
	e.Sueldo,convert(char(10),e.FechaContrato,103)[FechaContrato]
	from Empleado e
	inner join Departamento d on d.IdDepartamento = e.IdDepartamento
)

go

create function fn_empleado(@idEmpleado int)
returns table
as
return
(
	select e.IdEmpleado,e.NombreCompleto,
	d.IdDepartamento,d.Nombre,
	e.Sueldo,convert(char(10),e.FechaContrato,103)[FechaContrato]
	from Empleado e
	inner join Departamento d on d.IdDepartamento = e.IdDepartamento
	where e.IdEmpleado = @idEmpleado
)

go

create procedure sp_CrearEmpleado(
@NombreCompleto varchar(50),
@IdDepartamento int,
@Sueldo decimal(10,2),
@FechaContrato varchar(10)
)
as
begin
	set dateformat dmy
	insert into Empleado(NombreCompleto,IdDepartamento,Sueldo,FechaContrato)
	values(@NombreCompleto,@IdDepartamento,@Sueldo,convert(date,@FechaContrato))
end

go

create procedure sp_EditarEmpleado(
@IdEmpleado int,
@NombreCompleto varchar(50),
@IdDepartamento int,
@Sueldo decimal(10,2),
@FechaContrato varchar(10)
)
as
begin
	set dateformat dmy
	update Empleado set
	NombreCompleto = @NombreCompleto,
	IdDepartamento = @IdDepartamento,
	Sueldo = @Sueldo,
	FechaContrato = convert(date,@FechaContrato)
	where IdEmpleado = @IdEmpleado
end

go 

create procedure sp_EliminarEmpleado(
@IdEmpleado int
)
as
begin
	delete from Empleado where IdEmpleado = @IdEmpleado
end
