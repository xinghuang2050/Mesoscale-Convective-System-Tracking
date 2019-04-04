# Mesoscale Convective System (MCS) Tracking Project

This MATLAB toolkit can be used to track MCS in satellite observation data. Users can set different criteria (such as size, duration, location) of targeted MCSs.  Examples for using it in distributed computing environments are also included.

## Software Prerequisites

A standard MATLAB environment is required to run this toolkit.

Qsub is used to run the tracking algorithm in a parallel computing cluster in our example, but it is not required. An introduction of qsub can be found [here](https://wikis.nyu.edu/display/NYUHPC/Tutorial+-+Submitting+a+job+using+qsub).

## File Organisition

```
.
├── README.md
├── code
│   ├── job_array.pbs
│   ├── pbs_run.m
│   ├── task_assign.m
│   └── utils
│       ├── ...
├── Fit_eccen.m
├── mcs_record.m
├── convert2txt.m
```

`Fit_eccen.m` is used for adding the eccentricty of MCSs
`mcs_record.m` is used for saving the output files(*.mat) of MCSs record
`convert2txt.m` is used for the convert of file as *.mat to *.txt

User examples can be found inside the main code directory `/code/`.
`/code/job_array.pbs` is an example of submitting parallel computing tasks in a qsub system.
`/code/pbs_run.m` is an example of tracking MCS by calling the main function with customised parameters.


Main code for the toolkit can be found inside `/code/utils/`.

## Usage

Here is a simple code structure of using the main function

```matlab
function run(array_size, array_id)
% ======
% parallel computing parameters:
% array_size: the amount of processes used in the process array.
% array_id: the id for current process
% ======

% ======
% step 1: set up experiment evironment
% ======
% set experiment name for output files
experiment_name = strcat('MCS_dataset', '01');
% set experiment path
output_dir= ""
input_dir= ""
source_code_path= "" % your local path for the matlab code 

addpath(genpath(source_code_path));

% ======
% step 2: run MCS tracking experiment
% ======


% Find out the time range assigned to current process. Here the total time range is [1985 Jan ~ 2008 Dec]
time_list  = task_assign(1985, 1, 2008,12, array_size, array_id);

% Call the main function with customized criteria 
% parameters:
% 'is_rewrite': bool flag for rewrite(or not) the output files if they already exist
% 'x1, x2, y1, y2': the rectangle area where we are looking for MCS. Using the coordination of input satellite image. It defines the tropical area in CLAUS in this example.
% 'age_threshold': the minimum duration of a MCS target. In the unit of time step of input satellite image.
% 'tracking_method': selecting tracking algorithm between 'overlapping', 'KF' or 'TO'. 'overlapping' uses traditional area overlapping based tracking. 'KF' use Kalman Filter only. 'TO' combines Kalman Filter with area overlapping.
% 'shield_temperature_threshold': the highest temperature threshold of the shield part of the convection system. In Kelvin.
% 'shield_area_threshold': the minimum area size of the shield part of the convection system. In the unit of squared kilometers.
% 'overlapping_rate_threshold': the pearcentage of overlapping area 
% 'interest_date_begin, interest_date_end, record_date_begin, record_date_end': time range for mcs tracking. Record time range is shorter than the interested time range in order to take the overlap of parallel processes into consideration. User can define the time range manually instead of using the automatically generated parameters as the example here.
mcsDetect(input_dir, output_dir,...
'is_rewrite', false,...
'x1', 180, 'x2', 360,...
'y1', 1, 'y2', 1080,...
'age_threshold', 3,...
'tracking_method', 'TO',...
'shield_temperature_threshold', 233,...
'shield_area_threshold', 5000,...
'overlapping_rate_threshold', 15,...
'interest_date_begin', time_list.interest_begin_date,...
'interest_date_end', time_list.interest_end_date,...
'record_date_begin', time_list.record_begin_date,...
'record_date_end', time_list.record_end_date)
```


More default and adjustable parameters for the main function can be  found in `/code/utils/default_parser.m`.

## Contributing

Please submitting pull requests to huangxing275@126.com.

## License

This project is licensed under the MIT License.


