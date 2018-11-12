import * as path from 'path';

export const InfrastructureDir = path.resolve('../infrastructure');
export const RealtimeDir = path.resolve('..//realtime');
export const QuizDir = path.resolve('../quiz');
export const CurveballControlDir = path.resolve('../curveball-control');

export const BackUpDir = `${InfrastructureDir}/backups`;
export const SchemaDir = `${InfrastructureDir}/schema`;
export const CertsDir = `${InfrastructureDir}/certs`;

export const DbContainerName = 'infrastructure_curveball-db_1';
export const RealtimeContainerName = 'infrastructure_curveball-realtime_1';
export const QuizContainerName = 'infrastructure_curveball-quiz_1';
export const CacheContainerName = 'infrastructure_curveball-cache_1';

export const DockerDirs = [RealtimeDir, CurveballControlDir];
