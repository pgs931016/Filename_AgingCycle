clc; clear; close all

% 루트 디렉토리 설정
rootDir = '/Users/g.park/Library/CloudStorage/GoogleDrive-gspark@kentech.ac.kr/공유 드라이브/BSL-Data/Data/Hyundai_dataset/AgingDOE_cycle1/RPT1';

% 루트 디렉토리 내의 모든 폴더 목록 가져오기 (하위 폴더 포함)
allFolders = dir(rootDir);
allFolders = allFolders(~ismember({allFolders.name}, {'.', '..'}));

a=1;

% 루트 디렉토리 내의 각 폴더에 대해 작업
for i = 1:length(allFolders)
    currentDir = fullfile(rootDir, allFolders(i).name);
    
    % 끝째 폴더의 이름 추출
    folderParts = strsplit(rootDir, filesep);
    replacementName = folderParts{end};
    replacementName = regexprep(replacementName, '_FCC', '');

    % 현재 폴더 내의 모든 txt 파일 가져오기 (하위 폴더 포함)
    files = dir(fullfile(currentDir, '*.txt'));

    % 각 파일에 대해 작업
    for j = 1:length(files)
        oldFilePath = fullfile(currentDir, files(j).name);
        fprintf('Processing file: %s\n', oldFilePath);

        % 파일 이름에서 필요한 부분 추출
        [~, fileName, fileExt] = fileparts(files(j).name);

        % 언더스코어(_)로 파일 이름을 분리
        parts = strsplit(fileName, '_');

        % 파일 이름 재구성
        if length(parts) >= 3
            % _108 부분에서 숫자 추출
            numPart = str2double(parts{5});
            idx = find(a == numPart);


            % 파일 이름 앞부분에 prefix를 추가
            if ~isempty(prefix_a) && ~isempty(prefix_b)
                newFileName = sprintf('HNE_%s_%d_%d%s', replacementName, a, numPart, fileExt);
                newFilePath = fullfile(rootDir, newFileName);
                success = movefile(oldFilePath, newFilePath);
            end
        end
    end
end