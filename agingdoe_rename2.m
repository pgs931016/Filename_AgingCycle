clc; clear; close all

% 루트 디렉토리 설정
root = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Data/Hyundai_dataset/AgingDOE_cycle1/AgingDOE1/열화인자조합(16)/HNE_FCC_4CPD_4C_V3542_231123_cyc/20231127';

% 루트 디렉토리 내의 모든 폴더 목록 가져오기 (하위 폴더 포함)
filelist = dir(fullfile(root, '*.txt'));
targetstring = '_FCC';

% 루트 디렉토리 내의 각 파일에 대해 작업
for i = 1:length(filelist)
    % 파일 경로 및 이름 설정
    currentfilename = filelist(i).name;
    currentfilepath = fullfile(root, currentfilename);
    
    % 새로운 파일 이름 생성 ('_FCC'를 제거)
    newfilename = strrep(currentfilename, targetstring, '');
    
    % 새로운 파일 경로 생성
    newfilepath = fullfile(root, newfilename);
    
    % 현재 파일 경로와 새 파일 경로가 같지 않은 경우에만 이동
    if ~strcmp(currentfilepath, newfilepath)
        movefile(currentfilepath, newfilepath);
    end
end
