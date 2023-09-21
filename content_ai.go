package servermanager

type CarAIOptions []string

func GetAIOptions() []string {
	return []string{"none", "fixed", "auto"}
}
