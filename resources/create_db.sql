create table meta (
    file_version_major int
  , file_version_minor int
  , created_on timestamp
  , last_updated timestamp
  , results_are_dirty_before timestamp
);
insert into meta (file_version_major, file_version_minor, created_on, last_updated, results_are_dirty_before)
  values (0, 1, datetime('now'), datetime('now'), datetime('now'));

create table fk_length_units (
    unit text primary key
  , multiplier real
);
insert into fk_length_units values ('meters', 1.0);
insert into fk_length_units values ('feet', 0.3048);
insert into fk_length_units values ('yards', 0.9144);

create table fk_time_units (
    unit text primary key
  , multiplier real
);
insert into fk_time_units values ('days', 1.0);
insert into fk_time_units values ('hours', 1.0/24.0);
insert into fk_time_units values ('minutes', 1.0/1440.0);
insert into fk_time_units values ('seconds', 1.0/86400.0);

create table fk_discharge_units(
  unit text primary key
, multiplier real
);
insert into fk_discharge_units values ('m3/day', 1.0);
insert into fk_discharge_units values ('ft3/sec', 2446.58);
insert into fk_discharge_units values ('gal/min', 5.45099);

create table fk_aquifer_drawdown_models (
  aquifer_drawdown_model text primary key
);
insert into fk_aquifer_drawdown_models values ('theis');
insert into fk_aquifer_drawdown_models values ('hantush-jacob');

create table fk_temporal_domain_types (
    temporal_domain_type text primary key
  , description text
);
insert into fk_temporal_domain_types values ('linear', 't0, tf, and tn are provided by user');
insert into fk_temporal_domain_types values ('freeform', 'Times are provided by user as list');
insert into fk_temporal_domain_types values ('wells', 'Times are coincident with observed water levels at wells');

create table settings (
    length_unit text references fk_length_units (length_unit)
  , time_unit text references fk_time_units (time_unit)
  , discharge_unit text references fk_discharge_units (discharge_unit)
  , aquifer_drawdown_model text references fk_aquifer_drawdown_models (aquifer_drawdown_model)
  , well_loss_turbulant_on boolean default false
  , well_loss_laminar_on boolean default false
  , well_loss_transient_on boolean default false
  , h0_transient_on boolean default false
);

insert into settings 
(length_unit, time_unit, discharge_unit, aquifer_drawdown_model, well_loss_turbulant_on, 
    well_loss_laminar_on, well_loss_transient_on, h0_transient_on)
values 
('meters', 'days', 'm3/day', 'theis', 0, 0, 0, 0);
                      

create table wells (
    name text primary key
  , x real
  , y real
  , rw real
  , h0 real
  , dh0 real default 0
  , b real default 0
  , db real default 0
  , c real default 0
  , dc real default 0
);

create table aquifer_drawdown_model_parameters (
  name text primary key
, value real
);
insert into aquifer_drawdown_model_parameters values ('S', NULL);
insert into aquifer_drawdown_model_parameters values ('T', NULL);
insert into aquifer_drawdown_model_parameters values ('m*/K*', NULL);

create table pumping_rates (
    well text references wells (name)
  , t real
  , v real
);

create table pest_observed_heads (
    well text references wells (name)
  , t real
  , v real
);

create table pest_windows (
    well text references wells (name)
  , t0 real
  , tf real
)
