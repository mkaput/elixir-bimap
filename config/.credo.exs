%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      requires: [],
      check_for_updates: true,
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Refactor.PipeChainStart, false}
      ]
    }
  ]
}
