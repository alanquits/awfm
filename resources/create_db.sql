create table meta (
    file_version_major int
  , file_version_minor int
  , created_on timestamp
  , last_updated timestamp
  , results_are_dirty_before timestamp
);
insert into meta (file_version_major, file_version_minor, created_on, last_updated, results_are_dirty_before)
  values (0, 1, datetime('now'), datetime('now'), datetime('now'));

create table fk_unit_types (
    unit_type text
);
insert into fk_unit_types values ('length');
insert into fk_unit_types values ('time');
insert into fk_unit_types values ('discharge');

create table fk_length_units (
    unit text
  , multiplier real
);
insert into fk_length_units values ('meters', 1.0);
insert into fk_length_units values ('feet', 0.3048);
insert into fk_length_units values ('yards', 0.9144);

create table fk_time_units (
    unit text
  , multiplier real
);
insert into fk_time_units values ('days', 1.0);
insert into fk_time_units values ('hours', 1.0/24.0);
insert into fk_time_units values ('minutes', 1.0/1440.0);
insert into fk_time_units values ('seconds', 1.0/86400.0);

create table fk_discharge_units(
  unit text
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

create table fk_well_loss_models (
  well_loss_model text primary key
);
insert into fk_well_loss_models values ('jacob');
insert into fk_well_loss_models values ('simplified jacob');

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
);

create table wells (
    name text primary key
  , x real
  , y real
  , rw real
  , h0 real
  , well_loss_model text references fk_well_loss_models (well_loss_model)
);

create table aquifer_drawdown_model_parameters (
  shortname text primary key
, longname text
, value real
);
insert into aquifer_drawdown_model_parameters values ('S', 'storativity', NULL);
insert into aquifer_drawdown_model_parameters values ('T', 'transmissivity', NULL);
insert into aquifer_drawdown_model_parameters values ('m*/K*', 'aquitard thickness/vertical conductivity', NULL);

create table well_loss_model_parameters (
    shortname text primary key
  , longname text
);
insert into well_loss_model_parameters values ('B', 'well-loss due to laminar flow');
insert into well_loss_model_parameters values ('C', 'well-loss due to turbulant flow');

create table well_loss_model_parameter_values (
    well text references wells (name)
  , well_loss_model references fk_well_loss_models (well_loss_model)
  , shortname references well_loss_model_parameters (shortname)
  , value real
);

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
